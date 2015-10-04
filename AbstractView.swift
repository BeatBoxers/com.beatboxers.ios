//
//  AbstractView.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 23/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit

class AbstractView : UIView {
	override init (frame : CGRect) {
		super.init(frame: frame)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func width(usePadding: Bool = false) -> CGFloat {
		if usePadding {
			return (frame.size.width - (DEFAULT_PADDING * 2))
		}
		
		return frame.size.width
	}
	
	func height(usePadding: Bool = false) -> CGFloat {
		if usePadding {
			return (frame.size.height - (DEFAULT_PADDING * 2))
		}
		
		return frame.size.height
	}
}