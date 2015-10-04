//
//  Microduino.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 24/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import Foundation
import CoreBluetooth

class Microduino: BBDevice {
	static private let LOG_TAG = "Microduino"
	
	static let DEVICE_NAME = "BeatBoxers"
	
	static private var receivedQueue = ""

	static let SERVICE_UUID = CBUUID(string: "0000fff0-0000-1000-8000-00805f9b34fb")
	static let RECEIVE_UUID = CBUUID(string: "0000fff6-0000-1000-8000-00805f9b34fb")
	static let CLIENT_CONFIG_UUID = CBUUID(string: "00002902-0000-1000-8000-00805f9b34fb")
	
	static func hitReceived(received: String) {
		for char in received {
			if char == ";" {
				//split receivedQueue on -, [0] = padNumber, [1] = strength
				let parts = receivedQueue.componentsSeparatedByString("-")
				
				AudioPlayer.sharedInstance.play(getInstrument(parts[0].toInt()!), strength: parts[1].toInt()!)
				receivedQueue = ""//and reset out queue
			}
			else {
				receivedQueue.append(char)
			}
		}
		
		Log.v(LOG_TAG, "Hit received: "+String(received))
	}
	
	static func getInstrument(padNumber: Int) -> String {
		if 1 == padNumber {
			return AudioPlayer.BASS
		}
		else if 2 == padNumber {
			return AudioPlayer.CRASH
		}
		else if 3 == padNumber {
			return AudioPlayer.FLOOR_TOM
		}
		else if 4 == padNumber {
			return AudioPlayer.HIGH_HAT
		}
		else if 5 == padNumber {
			return AudioPlayer.RIDE
		}
		else if 6 == padNumber {
			return AudioPlayer.SNARE
		}
		else if 7 == padNumber {
			return AudioPlayer.TOM_1
		}
		else if 8 == padNumber {
			return AudioPlayer.TOM_2
		}
		
		return AudioPlayer.UNKNOWN
	}
}