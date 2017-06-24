//
//  ViewController.swift
//  Client
//
//  Created by 唐三彩 on 2017/6/19.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import ProtocolBuffers

class ViewController: UIViewController {
    
    //    fileprivate lazy var tcpClient : TCPClient = TCPClient(addr: "192.168.1.100", port: 7999)
    fileprivate lazy var socket : SANSocket = SANSocket(addr: "192.168.1.121", port: 7999)
    fileprivate var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if socket.connectServer(10) {
            print("连接成功")
            socket.startReadMsg()
            
            timer = Timer(fireAt: Date(), interval: 8, target: self, selector: #selector(sendBeatsData), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        }
        
    }
    
    deinit {
        timer.invalidate()
        timer = nil
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            socket.sendJoinMsg()
        case 1:
            socket.sendLeaveMsg()
        case 2:
            socket.sendTextMsg("你好")
        case 3:
            socket.sendGiftMsg("鲜花", "http://www.abc.com", 1000)
        default:
            print("未识别消息")
        }
    }
}

extension ViewController {
    @objc fileprivate func sendBeatsData() {
        print("发送beats");
        socket.sendBeatsData()
    }
}

