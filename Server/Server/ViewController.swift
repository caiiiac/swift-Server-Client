//
//  ViewController.swift
//  Server
//
//  Created by 唐三彩 on 2017/6/19.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var hintLabel: NSTextField!
    fileprivate lazy var serverSocket : ServerSocket = ServerSocket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startServer(_ sender: NSButton) {
        hintLabel.stringValue = "服务器已经开启ing"
        
        serverSocket.startRunning("0.0.0.0", 7999)
    }
    
    @IBAction func stopServer(_ sender: NSButton) {
        hintLabel.stringValue = "服务器未开启"
        
        serverSocket.stopRunning()
    }
}
