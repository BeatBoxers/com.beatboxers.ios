//
//  BTViewController.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 23/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import Foundation

class BTViewController: AbstractViewController {
	internal let btManager = BTManager.sharedInstance
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "btEnabled", name: Notification.BLUETOOTH_ENABLED, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "btDisabled", name: Notification.BLUETOOTH_DISABLED, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "btConnectPeripheral:", name: Notification.BLUETOOTH_CONNECT_PERIPHERAL, object: nil)
		
		self.navigationController?.title = translate("BeatBoxers")
	}
	
	func btEnabled() {
	}
	
	func btDisabled() {
	}
	
	func btConnectPeripheral(notification: NSNotification) {
		
	}
}