//
//  PlayerViewController.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 24/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit
import CoreBluetooth

class PlayerViewController: BTViewController, BTDelegate {
	let LOG_TAG = "PlayerViewController"
	
	private var playerView: PlayerView?
	/*
	class DeviceConnectionCallback: BTDeviceConnectionCallback {
		let LOG_TAG = "PlayerViewController.DeviceConnectionCallback"
		
		var parentClass: PlayerViewController
		
		required init(parent: AnyObject) {
			if let x = parent as? PlayerViewController {
				parentClass = x
			}
			else {
				fatalError("Parent class must be of type PlayerViewController")
			}
		}
		
		func connected(peripheral: CBPeripheral) {
			Log.i(LOG_TAG, "Connected to device: "+trim(peripheral.name))
			
			let searchingTag = BBDevice.getViewTag(trim(peripheral.name))
			
			for deviceView in parentClass.deviceViews {
				if (deviceView.tag == searchingTag) {
					deviceView.connected()
				}
			}
		}
		
		func connectionError(peripheral: CBPeripheral) {
			Log.i(LOG_TAG, "Connection error for device: "+trim(peripheral.name))
		}
		
		func disconnected(peripheral: CBPeripheral) {
			Log.i(LOG_TAG, "Disconected from device: "+trim(peripheral.name))
		}
	}
	*/
	
	/*
		UIViewController overloads
	*/
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Log.i(LOG_TAG, "viewDidLoad")
		
		//setup the callbacks
		btManager.delegate = self
		
		//setup our views
		playerView = PlayerView(frame: CGRectMake(0, startY(), width(), height()))
		
		view.addSubview(playerView!)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	/*
		BTViewController overrides
	*/
	override func btConnectPeripheral(notification: NSNotification) {
		if notification.name == Notification.BLUETOOTH_CONNECT_PERIPHERAL {
			let dictonary: NSDictionary = notification.userInfo!
			let peripheral: CBPeripheral = dictonary.objectForKey("peripheral") as! CBPeripheral
			
			playerView?.connecting(peripheral)
			btManager.connect(peripheral)
		}
	}
	
	/*
		BTDelegate methods
	*/
	func connected(peripheral: CBPeripheral) {
		Log.i(LOG_TAG, "Connected to: "+trim(peripheral.name))
		
		playerView?.connected(peripheral)
	}
	
	func connectionError(peripheral: CBPeripheral) {
		Log.e(LOG_TAG, "Connection error for peripheral: "+trim(peripheral.name))
		
		playerView?.disconnected(peripheral)
	}
	
	func disconnected(peripheral: CBPeripheral) {
		Log.e(LOG_TAG, "Lost connection to peripheral: "+trim(peripheral.name))
		
		playerView?.disconnected(peripheral)
	}
}