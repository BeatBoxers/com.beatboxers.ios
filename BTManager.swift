//
//  Scanner.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 21/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import Foundation
import CoreBluetooth

//Callback protocols
protocol BTDelegate {
	func connected(peripheral: CBPeripheral)
	func connectionError(peripheral: CBPeripheral)
	func disconnected(peripheral: CBPeripheral)
}

protocol BTScanDelegate {
	func foundDevice(peripheral: CBPeripheral)
}

//Class
private let BTManagerSingletonInstance = BTManager()

class BTManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
	private let LOG_TAG = "BTManager"
	
	class var sharedInstance: BTManager {
		return BTManagerSingletonInstance
	}
	
	private var centralManager: CBCentralManager?
	private var scanTimer: NSTimer?
	private var connectTimer: NSTimer?
	internal var delegate: BTDelegate?
	internal var scanDelegate: BTScanDelegate?
	
	override init() {
		super.init()
		
		let centralQueue = dispatch_queue_create("com.beatboxers", DISPATCH_QUEUE_SERIAL)
		centralManager = CBCentralManager(delegate: self, queue: centralQueue)
	}
	
	func currentState() -> CBCentralManagerState {
		return centralManager!.state
	}
	
	func enabled() -> Bool {
		return (currentState() == .PoweredOn)
	}
	
	func startScanning() {
		Log.i(LOG_TAG, "Start scanning")
		centralManager!.scanForPeripheralsWithServices([Microduino.SERVICE_UUID, Rfduino.SERVICE_UUID], options: nil)
		
		scanTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "stopScanning", userInfo: nil, repeats: false)
	}
	
	func stopScanning() {
		Log.i(LOG_TAG, "Stop scanning")
		
		scanTimer?.invalidate()//dont re-fire the stopScan func due to timers
		centralManager!.stopScan()
	}
	
	func connect(peripheral: CBPeripheral) {
		Log.i(LOG_TAG, "attempting to connect to "+trim(peripheral.name))
		
		scanTimer?.invalidate()//stop scanning if we have decided to reconnect
		centralManager!.connectPeripheral(peripheral, options: nil)
		
		connectTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "connectionTimeout:", userInfo: ["peripheral" : peripheral], repeats: false)
	}
	
	func disconnect(peripheral: CBPeripheral) {
		Log.i(LOG_TAG, "Disconnecting from: "+trim(peripheral.name))
		
		centralManager!.cancelPeripheralConnection(peripheral)
	}
	
	/*
		CBCentralManagerDelegate methods
	*/
	func centralManagerDidUpdateState(central: CBCentralManager!) {
		var notification = Notification.BLUETOOTH_DISABLED
		
		switch central.state {
			case .PoweredOn:
				Log.i(LOG_TAG, "BT status updated: powered on")
				
				notification = Notification.BLUETOOTH_ENABLED
			case .PoweredOff:
				Log.i(LOG_TAG, "BT status updated: powered off")
			case .Resetting:
				Log.i(LOG_TAG, "BT status updated: resetting")
			case .Unauthorized:
				Log.i(LOG_TAG, "BT status updated: unauthorized")
			case .Unknown:
				Log.i(LOG_TAG, "BT status updated: unknown")
			case .Unsupported:
				Log.i(LOG_TAG, "BT status updated: Unsupported")
		}
		
		//make sure we are calling our nofification on our main thread or all UI updates will take forever
		dispatch_async(dispatch_get_main_queue(), {
			NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
		})
	}
	
	func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
		// Validate peripheral information
		if peripheral == nil || peripheral.name == nil || peripheral.name == "" {
			return
		}
		
		if let callback = scanDelegate {
			//make sure we are calling our nofification on our main thread or all UI updates will take forever
			dispatch_async(dispatch_get_main_queue(), {
				callback.foundDevice(peripheral)
			})
		}
	}
	
	func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
		connectTimer?.invalidate()
		
		peripheral.delegate = self
		peripheral.discoverServices([BBDevice.getServiceUUID(peripheral.name)])
	}
	
	func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
		connectTimer?.invalidate()
		
		if let callback = delegate {
			//make sure we are calling our nofification on our main thread or all UI updates will take forever
			dispatch_async(dispatch_get_main_queue(), {
				callback.connectionError(peripheral)
			})
		}
	}
	
	//custom delegate method
	func connectionTimeout(timer: NSTimer) {
		Log.i(LOG_TAG, "Peripheral connection timeout")
		
		var dictonary: NSDictionary? = timer.userInfo as? NSDictionary
		var peripheral: CBPeripheral = dictonary?.objectForKey("peripheral") as! CBPeripheral
		
		centralManager!.cancelPeripheralConnection(peripheral)
	}
	
	func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
		connectTimer?.invalidate()
		
		if let callback = delegate {
			//make sure we are calling our nofification on our main thread or all UI updates will take forever
			dispatch_async(dispatch_get_main_queue(), {
				callback.disconnected(peripheral)
			})
		}
	}
	
	/*
		CBPeripheralDelegate methods
	*/
	func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
		let searchingUUID = BBDevice.getServiceUUID(peripheral.name)
		
		for service in peripheral.services {
			if (service.UUID == searchingUUID) {
				peripheral.discoverCharacteristics([BBDevice.getReceiveUUID(peripheral.name)], forService: service as! CBService)
				return
			}
		}
	}
	
	func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
		let searchingUUID = BBDevice.getReceiveUUID(peripheral.name)
		
		for characteristic in service.characteristics {
			if characteristic.UUID == searchingUUID {
				if let callback = delegate {
					peripheral.setNotifyValue(true, forCharacteristic: characteristic as! CBCharacteristic)
					
					//make sure we are calling our nofification on our main thread or all UI updates will take forever
					dispatch_async(dispatch_get_main_queue(), {
						callback.connected(peripheral)
					})
				}
				
				return
			}
		}
	}
	
	func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
		let searchingUUID = BBDevice.getReceiveUUID(peripheral.name)
		
		if searchingUUID == characteristic.UUID {
			let value = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding) as! String
			
			dispatch_async(dispatch_get_main_queue(), {
				if trim(peripheral.name) == Microduino.DEVICE_NAME {
					Microduino.hitReceived(value)
				}
				else if trim(peripheral.name) == Rfduino.DEVICE_NAME {
					Rfduino.hitReceived(value)
				}
			})
		}
	}
}