//
//  ServerSocket.swift
//  Server
//
//  Created by 唐三彩 on 2017/6/21.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import Cocoa

class ServerSocket: NSObject {
    var tcpServer : TCPServer?
    var isServerRunning : Bool = false
    
    fileprivate lazy var clientMgrs : [ClientManager] = [ClientManager]()
}

// MARK:- 对外提供函数
extension ServerSocket {
    func startRunning(_ address : String, _ port : Int) {
        // 1.创建TCPServer
        tcpServer = TCPServer(addr: address, port: port)
        
        // 2.开始监听客户端连接
        tcpServer?.listen()
        
        // 3.接收客户端的连接
        isServerRunning = true
        DispatchQueue.global().async {
            while self.isServerRunning {
                if let client = self.tcpServer?.accept() {
                    DispatchQueue.global().async {
                        self.handleClient(client)
                    }
                }
            }
        }
    }
    
    func stopRunning() {
        isServerRunning = false
    }
    
    func handleClient(_ client : TCPClient) {
        // 1.保存client客户端
        let clientMgr = ClientManager(tcpClient: client)
        clientMgrs.append(clientMgr)
        
        // 3.设置代理
        clientMgr.delegate = self
        
        // 2.等待client客户端发送过来消息
        clientMgr.startReadMsg()
    }
    
}


extension ServerSocket : ClientManagerDelegate {
    func removeClient(_ client: ClientManager) {
        guard let index = clientMgrs.index(of: client) else { return }
        clientMgrs.remove(at: index)
    }
    
    func forwardMessage(_ client: ClientManager, msgData: Data, isLeave: Bool) {
        if isLeave {
            let index = clientMgrs.index(of: client)!
            clientMgrs.remove(at: index)
        }
        
        for client in clientMgrs {
            client.sendMsg(msgData)
        }
    }
}

