//
//  ViewController.swift
//  BluetoothTest
//
//  Created by AidaAkihiro on 2015/01/09.
//  Copyright (c) 2015年 AidaAkihiro. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate {
    
    var myTableView: UITableView!
    var myUuids: NSMutableArray = NSMutableArray()
    var myNames: NSMutableArray = NSMutableArray()
    
    var myCentralManager:CBCentralManager!
    var myTargetPeripheral:CBPeripheral!
    let myButton: UIButton = UIButton()
    
//    let dataSets = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status Barの高さを取得.
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        
        // Viewの高さと幅を取得.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成( status barの高さ分ずらして表示 ).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        // Cellの登録.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        // DataSourceの設定.
        myTableView.dataSource = self
        // Delegateを設定.
        myTableView.delegate = self
        // Viewに追加する.
        self.view.addSubview(myTableView)
        
        // サイズ
        myButton.frame = CGRectMake(0,0,200,40)
        myButton.backgroundColor = UIColor.redColor();
        myButton.layer.masksToBounds = true
        myButton.setTitle("検索", forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height-50)
        myButton.tag = 1
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    ボタンイベント.
    */
    func onClickMyButton(sender: UIButton){
        // CoreBluetoothを初期化および始動.
        myCentralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    // MARK: - BluetoothCentral
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        println("state \(central.state)");
        switch (central.state) {
        case .PoweredOff:
            println("Bluetoothの電源がOff")
        case .PoweredOn:
            println("Bluetoothの電源はOn")
            // BLEデバイスの検出を開始.
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil)
        case .Resetting:
            println("レスティング状態")
        case .Unauthorized:
            println("非認証状態")
        case .Unknown:
            println("不明")
        case .Unsupported:
            println("非対応")
        }
    }
    
    /*
    BLEデバイスが検出された際に呼び出される.
    */
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("pheripheral.name: \(peripheral.name)")
        println("advertisementData:\(advertisementData)")
        println("RSSI: \(RSSI)")
        println("peripheral.identifier.UUIDString: \(peripheral.identifier.UUIDString)")
        
        var name: NSString!
        if peripheral.name == nil {
            name = "no name"
        } else {
            name = peripheral.name
        }
        myNames.addObject(name)
        
        myUuids.addObject(peripheral.identifier.UUIDString)
        
        myTableView.reloadData()
    }
    
    // MARK: - UITableView
    
    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Num: \(indexPath.row)")
        println("Uuid: \(myUuids[indexPath.row])")
        println("Name: \(myNames[indexPath.row])")
    }
    
    /*
    Cellの総数を返す.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUuids.count
    }
    
    /*
    Cellに値を設定する.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"MyCell" )
        
        // Cellに値を設定.
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.redColor()
        cell.textLabel!.text = "\(myNames[indexPath.row])"
        cell.textLabel!.font = UIFont.systemFontOfSize(20)
        // Cellに値を設定(下).
        cell.detailTextLabel!.text = "\(myUuids[indexPath.row])"
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)
        return cell
    }
    
}

