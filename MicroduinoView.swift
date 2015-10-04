//
//  MicroduinoPlayer.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 24/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit
import CoreBluetooth

class MicroduinoView: AbstractBBDeviceView {
	let pantsImage = UIImage(named: "Pants")
	let pantsImageView = UIImageView()
	
	override init (frame : CGRect, peripheral: CBPeripheral) {
		super.init(frame: frame, peripheral: peripheral)
		
		pantsImageView.frame = CGRectMake(0, AbstractBBDeviceView.HEADER_HEIGHT, width(), height() - AbstractBBDeviceView.HEADER_HEIGHT)
		pantsImageView.image = pantsImage
		
		addSubview(pantsImageView)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}