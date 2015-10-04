//
//  ScanContainerView.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 29/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanContainerView: AbstractView, BTScanDelegate, UITableViewDataSource, UITableViewDelegate {
	private let btManager = BTManager.sharedInstance
	private var discoveredPeripherals = [CBPeripheral]()
	private var scanView: ScanView?
	
	override init (frame : CGRect) {
		super.init(frame: frame)
		
		//set the background as "disabled"
		backgroundColor = Color.BLOCKED_BACKGROUD
		
		//start building the table view popup
		let margin: CGFloat = 20
		
		scanView = ScanView(frame: CGRectMake(margin, margin, width() - (margin * 2), height() - (margin * 2)))
		scanView?.tableView.dataSource = self
		scanView?.tableView.delegate = self
		scanView?.cancelButton.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
		
		addSubview(scanView!)
		
		btManager.scanDelegate = self
		btManager.stopScanning()//just to make sure we are not scanning before starting a new scan
		btManager.startScanning()
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func removeFromSuperview() {
		super.removeFromSuperview()
	}
	
	/*
	ScanView private methods
	*/
	func cancel() {
		removeFromSuperview()
	}
	
	/*
	BTScanDelegate methods
	*/
	func foundDevice(peripheral: CBPeripheral) {
		if !contains(discoveredPeripherals, peripheral) {
			discoveredPeripherals.append(peripheral)
			scanView?.tableView.reloadData()
		}
	}
	
	/*
	UITableView delegate methods
	*/
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return discoveredPeripherals.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(ScanView.TABLE_CELL_IDENTIFIER) as! UITableViewCell
		
		let row = indexPath.row
		cell.textLabel?.text = discoveredPeripherals[row].name
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let peripheral = discoveredPeripherals[indexPath.row]
		
		NSNotificationCenter.defaultCenter().postNotificationName(Notification.BLUETOOTH_CONNECT_PERIPHERAL, object: nil, userInfo: ["peripheral" : peripheral])
		
		removeFromSuperview()
	}
}