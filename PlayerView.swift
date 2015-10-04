//
//  PlayerView.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 29/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit
import CoreBluetooth

class PlayerView: AbstractView {
	let LOG_TAG = "PlayerView"
	
	private var playerHeaderView: PlayerHeaderView?
	
	override init (frame : CGRect) {
		super.init(frame: frame)
		
		playerHeaderView = PlayerHeaderView(frame: CGRectMake(DEFAULT_PADDING, DEFAULT_PADDING, width(usePadding: true), PlayerHeaderView.HEIGHT + DEFAULT_PADDING))
		playerHeaderView?.scanButton.addTarget(self, action: "scan", forControlEvents: .TouchUpInside)
		
		addSubview(playerHeaderView!)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func scan() {
		Log.i(LOG_TAG, "Start scanning")
		
		let scanContainerView = ScanContainerView(frame: CGRectMake(0, 0, width(), height()))
		
		addSubview(scanContainerView)
	}
	
	func connecting(peripheral: CBPeripheral) {
		getPeripheralView(peripheral).connecting()
		playerHeaderView?.connecting(peripheral.hash)
	}
	
	func connected(peripheral: CBPeripheral) {
		getPeripheralView(peripheral).connected()
		playerHeaderView?.connected(peripheral.hash)
	}
	
	func disconnected(peripheral: CBPeripheral) {
		getPeripheralView(peripheral).disconnected()
		playerHeaderView?.disconnected(peripheral.hash)
	}
	
	func getPeripheralView(peripheral: CBPeripheral) -> AbstractBBDeviceView {
		for view in subviews {
			if let peripheralView = view as? AbstractBBDeviceView {
				if peripheralView.peripheral.hash == peripheral.hash {
					return peripheralView
				}
			}
		}
		
		//didn't find a view, create a new one
		let playerHeaderViewEndY = playerHeaderView!.frame.origin.y + playerHeaderView!.frame.size.height
		var view: AbstractBBDeviceView
		
		if peripheral.name == Rfduino.DEVICE_NAME {
			view = RfduinoView(frame: CGRectMake(
				DEFAULT_PADDING,
				playerHeaderViewEndY,
				width(usePadding: true),
				height(usePadding: true) - playerHeaderViewEndY),
				peripheral: peripheral
			)
		}
		else {
			view = MicroduinoView(frame: CGRectMake(
				DEFAULT_PADDING,
				playerHeaderViewEndY,
				width(usePadding: true),
				height(usePadding: true) - playerHeaderViewEndY),
				peripheral: peripheral
			)
		}
		
		addSubview(view)
		
		let button = playerHeaderView!.newPeripheral(peripheral.hash)
		button.addTarget(self, action: "peripheralButtonTouched:", forControlEvents: .TouchUpInside)
		
		//since this is a brand new view, lets set it to being active
		setActiveView(peripheral.hash)
		
		return view
	}
	
	func peripheralButtonTouched(button: UIButton) {
		setActiveView(button.tag)//update our main views visibility first
		
		playerHeaderView?.switchActiveButton(button.tag)
	}
	
	func setActiveView(peripheralHash: Int) {
		playerHeaderView?.switchActiveButton(peripheralHash)
		
		for view in subviews {
			if let peripheralView = view as? AbstractBBDeviceView {
				if peripheralView.peripheral.hash == peripheralHash {
					peripheralView.hidden = false
				}
				else {
					peripheralView.hidden = true
				}
			}
		}
	}
}