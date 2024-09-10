//
//  SocketClient.swift
//  SampleChat
//
//  Created by AGM Tazim on 11/9/24.
//

import Foundation
import SocketIO

class SocketClient {
    static let shared = SocketClient()
    let manager = SocketManager(socketURL: URL(string: "socket_server_url")!, config: [.log(true), .compress])
    let socket: SocketIOClient
    
    private init() {
        self.socket = manager.defaultSocket
    }

    func connect() {
        socket.connect()
    }
    
    func initialize() {
        observeOnConnectEvent()
        observeOnDisConnectEvent()
    }
    
    func observeOnConnectEvent() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
    }
    
    func observeOnDisConnectEvent() {
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected")
        }
    }
    
    func observeOnReceiveMessageEvent(onReceiveMessage: @escaping (String)->Void) {
        socket.on("receiveMessage") {data, ack in
            guard let message = data[0] as? String else { return }
            
            onReceiveMessage(message)
            ack.with("Got your message", "dude")
        }
    }
    
    func emitMessage(message: String) {
        socket.emitWithAck("sendMessage", message).timingOut(after: 0) { [weak self] data in
            if data.first as? String ?? "passed" == SocketAckStatus.noAck {
                // Handle ack timeout
            }
        }
    }
    
    func postMessageNotification(message: String) {
        let dataDict: [String: String] = ["message": message]
        
        NotificationCenter.default.post(
          name: Notification.Name("receive_message"),
          object: nil,
          userInfo: dataDict
        )
    }
}
