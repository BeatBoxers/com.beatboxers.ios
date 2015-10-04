//
//  Service.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 21/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import Foundation
import CoreBluetooth

class BBDevice: NSObject {
	static func getServiceUUID(name: String) -> CBUUID {
		if name == Rfduino.DEVICE_NAME {
			return Rfduino.SERVICE_UUID
		}
		
		return Microduino.SERVICE_UUID
	}
	
	static func getReceiveUUID(name: String) -> CBUUID {
		if name == Rfduino.DEVICE_NAME {
			return Rfduino.RECEIVE_UUID
		}
		
		return Microduino.RECEIVE_UUID
	}
}