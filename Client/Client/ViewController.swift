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
    fileprivate lazy var socket : SANSocket = SANSocket(addr: "192.168.1.108", port: 7999)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if socket.connectServer(10) {
            print("连接成功")
            socket.startReadMsg()
        }
        
        /*
         if tcpClient.connect(timeout: 5).0 {
         let p = Person.Builder()
         p.id = 19880101
         p.name = "coderwhy"
         p.email = "372623326@qq.com"
         
         let pdata = (try! p.build()).data()
         
         // 1.用户记录长度的data
         var length = pdata.count
         let lengthData = Data(bytes: &length, count: 4)
         //            _ = tcpClient.send(data: lengthData)
         
         // 2.发哦少年宫类型
         var type = 2
         let typeData = Data(bytes: &type, count: 2)
         //            _ = tcpClient.send(data: typeData)
         
         // 3.发送真实消息
         let data = lengthData + typeData + pdata
         _ = tcpClient.send(data: data)
         }
         */
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
            socket.sendGiftMsg("服务商", "http://www.abc.com", 1000)
        default:
            print("未识别消息")
        }
    }
}



