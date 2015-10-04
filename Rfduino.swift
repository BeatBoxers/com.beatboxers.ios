//
//  Rfduino.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 24/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import Foundation
import CoreBluetooth

class Rfduino: BBDevice {
	static let DEVICE_NAME = "BeatS"
	
	static let SERVICE_UUID = CBUUID(string: "00002220-0000-1000-8000-00805f9b34fb")
	static let RECEIVE_UUID = CBUUID(string: "00002221-0000-1000-8000-00805f9b34fb")
	static let CLIENT_CONFIG_UUID = CBUUID(string: "00002902-0000-1000-8000-00805f9b34fb")
	
	static func hitReceived(received: String) {
		
	}
}