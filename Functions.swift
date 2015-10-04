//
//  Translate.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 23/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit

func translate(text: String) -> String {
	return text
}

func trim(text: String) -> String {
	return text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
}

func addBorder(view: UIView, color: CGColor = UIColor.yellowColor().CGColor) {
	view.layer.borderColor = color
	view.layer.borderWidth = 2
}