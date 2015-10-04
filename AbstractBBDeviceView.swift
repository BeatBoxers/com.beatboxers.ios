//
//  AbstractPlayerDeviceView.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 24/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit
import CoreBluetooth

class AbstractBBDeviceView: AbstractView {
	static let HEADER_HEIGHT: CGFloat = 50
	
	internal let peripheral: CBPeripheral
	
	private let headerView = UIView()
	private let connectingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
	private let reconnectButton = UIButton()
	
	init (frame : CGRect, peripheral: CBPeripheral) {
		self.peripheral = peripheral
		
		super.init(frame: frame)
		
		headerView.frame = CGRectMake(0, 0, width(), AbstractBBDeviceView.HEADER_HEIGHT)
		headerView.backgroundColor = Color.DISCONNECTED_BACKGROUND
		
		let actionFrame = CGRectMake(width() - 50, 0, 50, AbstractBBDeviceView.HEADER_HEIGHT)
		
		let deviceName = UILabel()
		deviceName.frame = CGRectMake(DEFAULT_PADDING, 0, width() - actionFrame.width - DEFAULT_PADDING, AbstractBBDeviceView.HEADER_HEIGHT)
		deviceName.textColor = Color.PERIPHERAL_TEXT
		deviceName.text = peripheral.name
		
		connectingSpinner.frame = actionFrame
		connectingSpinner.startAnimating()
		connectingSpinner.hidden = true
		
		reconnectButton.frame = actionFrame
		reconnectButton.setTitle("RC", forState: .Normal)
		reconnectButton.setTitleColor(Color.PERIPHERAL_TEXT, forState: .Normal)
		reconnectButton.addTarget(self, action: "reconnect", forControlEvents: .TouchUpInside)
		reconnectButton.hidden = true
		
		headerView.addSubview(deviceName)
		headerView.addSubview(connectingSpinner)
		headerView.addSubview(reconnectButton)
		
		addSubview(headerView)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//actions
	func reconnect() {
		NSNotificationCenter.defaultCenter().postNotificationName(Notification.BLUETOOTH_CONNECT_PERIPHERAL, object: nil, userInfo: ["peripheral" : peripheral])
	}
	
	//set our view states
	func connecting() {
		headerView.backgroundColor = Color.CONNECTING_BACKGROUND
		connectingSpinner.hidden = false
		reconnectButton.hidden = true
	}
	
	func connected() {
		headerView.backgroundColor = Color.CONNECTED_BACKGROUND
		connectingSpinner.hidden = true
		reconnectButton.hidden = true
	}
	
	func disconnected() {
		headerView.backgroundColor = Color.DISCONNECTED_BACKGROUND
		connectingSpinner.hidden = true
		reconnectButton.hidden = false
	}
}