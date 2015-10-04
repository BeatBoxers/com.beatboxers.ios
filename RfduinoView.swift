//
//  RfduinoView.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 30/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit
import CoreBluetooth

class RfduinoView: AbstractBBDeviceView {
	override init (frame : CGRect, peripheral: CBPeripheral) {
		super.init(frame: frame, peripheral: peripheral)
		
		let label = UILabel()
		label.frame = CGRectMake(0, AbstractBBDeviceView.HEADER_HEIGHT, width(), height() - AbstractBBDeviceView.HEADER_HEIGHT)
		label.text = "BEATS"
		
		addSubview(label)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}