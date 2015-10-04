//
//  BluetoothDisabledView.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 23/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit

class BTDisabledView: AbstractView {
	internal let disabledLabel = UILabel()
	
	override init (frame : CGRect) {
		super.init(frame: frame)
		
		disabledLabel.frame = CGRectMake(0, 0, width(), height())
		disabledLabel.text = translate("Bluetooth is currently disabled, please turn on Bluetooth to continue.")
		disabledLabel.numberOfLines = 0
		disabledLabel.lineBreakMode = .ByWordWrapping
		
		self.addSubview(disabledLabel)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}