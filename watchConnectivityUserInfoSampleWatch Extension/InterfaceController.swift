//
//  InterfaceController.swift
//  watchConnectivityUserInfoSampleWatch Extension
//
//  Created by 長尾 聡一郎 on 2015/09/02.
//  Copyright © 2015年 長尾 聡一郎. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var countLabel: WKInterfaceLabel!
    var count:Int = 0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
            
            print("active Session in InterfaceController")
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func pushButton(tag: Int){
        dispatch_async(dispatch_get_main_queue(), {
            self.statusLabel.setText("Sending..")
        })
        
        let message = ["sendMessageToPhone": "\(tag)"]
        
        WCSession.defaultSession().transferUserInfo(message)
        count = 0
    }
    
    @IBAction func pushDogButton() {
        self.pushButton(0)
    }

    @IBAction func pushCatButton() {
        self.pushButton(1)
    }
    
    @IBAction func pushElephantButton() {
            self.pushButton(2)
    }
    
    @IBAction func pushPenginButton() {
            self.pushButton(3)
    }
    
    @IBAction func pushManyButton() {
        for var i = 1; i < 100; i++ {
            let rand = arc4random() % 4
            let message:[String : AnyObject] = ["sendMessageToPhone" : "\(rand)"]
            WCSession.defaultSession().transferUserInfo(message)
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
            count++
            dispatch_async(dispatch_get_main_queue(), {
                self.statusLabel.setText(show)
                self.countLabel.setText("\(self.count)")
            })
        }
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        if let watchInfo = userInfo["sendMessageToWatch"] as? String {
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
                self.statusLabel.setText(show)
            })
        }
    }

}
