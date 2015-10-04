//
//  NavigationViewController.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 23/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit

let DEFAULT_PADDING: CGFloat = 5

class AbstractViewController: UIViewController {
	func startY(usePadding: Bool = false) -> CGFloat {
		if let navigationController = self.navigationController {
			if usePadding {
				return navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height + DEFAULT_PADDING
			}
			
			return navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
		}
		
		return 0
	}
	
	func width(usePadding: Bool = false) -> CGFloat {
		if usePadding {
			return (self.view.frame.size.width - (DEFAULT_PADDING * 2))
		}
		
		return self.view.frame.size.width
	}
	
	func height(usePadding: Bool = false) -> CGFloat {
		if usePadding {
			return (self.view.frame.size.height - startY(usePadding: true) - (DEFAULT_PADDING * 2))
		}
		
		return self.view.frame.size.height - startY()
	}
	
	func frame(usePadding: Bool = false) -> CGRect {
		var x = (usePadding ? DEFAULT_PADDING : 0)
		var y = startY(usePadding: usePadding)
		
		return CGRectMake(x, y, width(usePadding: usePadding), height(usePadding: usePadding))
	}
}