//
//  PlayerPeripherals.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 29/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit

class PlayerHeaderView: AbstractView {
	static let HEIGHT: CGFloat = 50
	
	let buttonWidth: CGFloat = 50
	
	let scanButton: UIButton = UIButton()
	var peripheralButtons = [UIButton]()
	let activeButtonView = UIView()
	var activeButtonTag: Int = 0
	
	override init (frame : CGRect) {
		super.init(frame: frame)
		
		scanButton.setTitle("+", forState: .Normal)
		scanButton.setTitleColor(Color.PERIPHERAL_TEXT, forState: .Normal)
		scanButton.backgroundColor = Color.BUTTON_SCAN_BACKGROUND
		
		activeButtonView.frame = CGRectMake(0, height() - DEFAULT_PADDING, buttonWidth, DEFAULT_PADDING)
		activeButtonView.hidden = true
		
		setButtonFrames()
		
		addSubview(scanButton)
		addSubview(activeButtonView)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func newPeripheral(tag: Int) -> UIButton {
		let button = UIButton()
		button.setTitle(String(peripheralButtons.count + 1), forState: .Normal)
		button.setTitleColor(Color.PERIPHERAL_TEXT, forState: .Normal)
		button.backgroundColor = Color.DISCONNECTED_BACKGROUND
		button.tag = tag
		
		peripheralButtons.append(button)
		
		setButtonFrames()
		
		addSubview(button)
		
		//a new peripheral means we should auto go to that view
		switchActiveButton(button.tag)
		
		return button
	}
	
	func switchActiveButton(tag: Int) {
		var view: UIButton? = viewWithTag(tag) as? UIButton
		
		if let button = view {
			activeButtonView.frame.origin.x = button.frame.origin.x
			activeButtonView.backgroundColor = button.backgroundColor
			activeButtonView.hidden = false
			activeButtonTag = tag//update our active button tag so we can change its color if needed on connection state change
		}
	}
	
	func connecting(tag: Int) {
		setButtonColor(tag, color: Color.CONNECTING_BACKGROUND)
	}
	
	func connected(tag: Int) {
		setButtonColor(tag, color: Color.CONNECTED_BACKGROUND)
	}
	
	func disconnected(tag: Int) {
		setButtonColor(tag, color: Color.DISCONNECTED_BACKGROUND)
	}
	
	func setButtonFrames() {
		var x: CGFloat = (buttonWidth * CGFloat(peripheralButtons.count)) + (DEFAULT_PADDING * CGFloat(peripheralButtons.count))
		
		scanButton.frame = CGRectMake(x, 0, buttonWidth, height() - DEFAULT_PADDING)
		
		for var i = 0; i < peripheralButtons.count; i++ {
			x = (buttonWidth * CGFloat(i)) + (DEFAULT_PADDING * CGFloat(i))
			
			peripheralButtons[i].frame = CGRectMake(x, 0, buttonWidth, height() - DEFAULT_PADDING)
		}
	}
	
	func setButtonColor(tag: Int, color: UIColor) {
		var view: UIButton? = viewWithTag(tag) as? UIButton
		
		if let button = view {
			button.backgroundColor = color
			
			if button.tag == activeButtonTag {
				activeButtonView.backgroundColor = color
			}
		}
	}
}