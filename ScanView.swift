//
//  ScanView.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 29/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanView: AbstractView {
	static let TABLE_CELL_IDENTIFIER: String = "ScanViewTableCell"
	
	let tableView: UITableView = UITableView()
	let cancelButton = UIButton()
	
	override init (frame : CGRect) {
		super.init(frame: frame)
		
		backgroundColor = Color.SCAN_HEADER_BACKGROUND
		layer.cornerRadius = 10
		layer.masksToBounds = true
		
		let edgeHeight: CGFloat = 50
		
		let headerLabel = UILabel(frame: CGRectMake(DEFAULT_PADDING, DEFAULT_PADDING, width(usePadding: true), edgeHeight))
		headerLabel.text = translate("Scanning for peripherals.")
		headerLabel.backgroundColor = Color.SCAN_HEADER_BACKGROUND
		
		let tableViewHeight: CGFloat = height(usePadding: true) - (edgeHeight * 2) - (DEFAULT_PADDING * 2)
		
		tableView.frame = CGRectMake(DEFAULT_PADDING, (edgeHeight + DEFAULT_PADDING), width(usePadding: true), tableViewHeight)
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ScanView.TABLE_CELL_IDENTIFIER)
		
		cancelButton.frame = CGRectMake(DEFAULT_PADDING, height(usePadding: true) - edgeHeight, width(usePadding: true), edgeHeight)
		cancelButton.setTitle(translate("Cancel"), forState: .Normal)
		cancelButton.setTitleColor(Color.BUTTON_TEXT, forState: .Normal)
		
		addSubview(headerLabel)
		addSubview(tableView)
		addSubview(cancelButton)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}