//
//  ClientManager.swift
//  Server
//
//  Created by 唐三彩 on 2017/6/19.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import Cocoa

protocol ClientManagerDelegate : class {
    func removeClient(_ client : ClientManager)
    func forwardMessage(_ client : ClientManager, msgData : Data, isLeave : Bool)
}

class ClientManager: NSObject {
    
    weak var delegate : ClientManagerDelegate?
    
    fileprivate var tcpClient : TCPClient
    fileprivate var isClientRunning : Bool = false
    
    init(tcpClient : TCPClient) {
        self.tcpClient = tcpClient
    }
}


extension ClientManager {
    func startReadMsg() {
        isClientRunning = true
        while isClientRunning {
            // 1.取出长度消息
            if let lengthMsg = tcpClient.read(4) {
                let lData = Data(bytes: lengthMsg, count: 4)
                var length : Int = 0
                (lData as NSData).getBytes(&length, length: 4)
                
                // 2.读取类型消息
                guard let typeMsg = tcpClient.read(2) else {
                    continue
                }
                
                var type : Int = 0
                let tdata = Data(bytes: typeMsg, count: 2)
                (tdata as NSData).getBytes(&type, length: 2)
                print(type)
                // 3.读取消息
                guard let msg = tcpClient.read(length) else {
                    continue
                }
                let msgData = Data(bytes: msg, count: length)
                
                // 4.消息转发出去
                let totalData = lData + tdata + msgData
                let isLeave = type == 1
                delegate?.forwardMessage(self, msgData: totalData, isLeave: isLeave)
            } else {
                isClientRunning = false
                delegate?.removeClient(self)
            }
        }
    }
    
    func sendMsg(_ data : Data) {
        _ = tcpClient.send(data: data)
    }
}
