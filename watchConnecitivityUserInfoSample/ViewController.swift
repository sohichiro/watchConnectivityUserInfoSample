//
//  ViewController.swift
//  watchConnecitivityUserInfoSample
//
//  Created by 長尾 聡一郎 on 2015/09/02.
//  Copyright © 2015年 長尾 聡一郎. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var outstandingLabel: UILabel!
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var remainSwitch: UISwitch!
    @IBOutlet weak var recirveLabel: UILabel!
    
    var count:Int = 0
    var sentCount:Int = 0
    var recerveCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            print("activate session")
            
            if session.paired != true {
                print("Apple Watch is not paired")
            }
            
            if session.watchAppInstalled != true {
                print("WatchKit app is not installed")
            }
            
        }else {
            print("WatchConnectivity is not supported on this device")
        }
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        if let watchInfo = userInfo["sendMessageToPhone"] as? String {
            var show:String
            
            if watchInfo == "0" {
                show = "🐶"
            }
            else if watchInfo == "1" {
                show = "🐱"
            }
            else if watchInfo == "2" {
                show = "🐘"
            }
            else {
                show = "🐧"
            }
            
            self.recerveCount++
            
            dispatch_async(dispatch_get_main_queue(), {
                self.statusLabel.text = show
                self.recirveLabel.text = String(self.recerveCount)

            })
        }
    }
    
    @IBAction func pushActionButton(sender: AnyObject) {
        let button = sender as! UIButton
        let message:[String : AnyObject] = ["sendMessageToWatch" : "\(button.tag)"]
        
        WCSession.defaultSession().transferUserInfo(message)
    }
    
    @IBAction func pushClearButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.statusLabel.text = "---"
        }
    }
    
    @IBAction func pushTenButton(sender: AnyObject) {
        self.sendManyUserInfo(10)
    }
    
    func sendManyUserInfo(limit:Int) {
        self.sentCount = 0
        self.count = limit
        for var i = 0; i < self.count; i++ {
            let rand = arc4random_uniform(3)
            let message:[String : AnyObject] = ["sendMessageToWatch" : "\(rand)"]
            WCSession.defaultSession().transferUserInfo(message)
            self.sentCount++
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.outstandingLabel.text = String(WCSession.defaultSession().outstandingUserInfoTransfers.count)
                self.sentLabel.text = String(self.sentCount)
            })
        }
    }
    
    func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: NSError?) {
        if let watchInfo = userInfoTransfer.userInfo["sendMessageToPhone"] as? String {
            var show:String
            
            if watchInfo == "0" {
                show = "🐶"
            }
            else if watchInfo == "1" {
                show = "🐱"
            }
            else if watchInfo == "2" {
                show = "🐘"
            }
            else {
                show = "🐧"
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.statusLabel.text = show
            })
            
            self.stopTransfer("1")
        }
    }
    
    func stopTransfer(sender: AnyObject) {
        if WCSession.defaultSession().outstandingUserInfoTransfers.count != 0 {
            for userInfo in WCSession.defaultSession().outstandingUserInfoTransfers {
                print("remain userInfo:\(WCSession.defaultSession().outstandingUserInfoTransfers.count)")
                if userInfo.transferring == true && self.remainSwitch.on == true && WCSession.defaultSession().outstandingUserInfoTransfers.count <= 3 {
                    userInfo.cancel()
                }
            }
        }
    }

}

