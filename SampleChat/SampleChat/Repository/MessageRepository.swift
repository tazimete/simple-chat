//
//  MessageRepository.swift
//  SampleChat
//
//  Created by AGM Tazim on 11/9/24.
//

import Foundation

class MessageRepository {
    let socketClient: SocketClient
    let apiClient: ApiClient
    
    init(
        socketClient: SocketClient = SocketClient.shared,
        apiClient: ApiClient = ApiClient.shared
    ) {
        self.socketClient = socketClient
        self.apiClient = apiClient
    }
    
    func postMessage(message: String) {
        socketClient.emitMessage(message: message)
    }
    
    func receiveMessage(onReceiveMessage: @escaping (String)->Void) {
        socketClient.observeOnReceiveMessageEvent(onReceiveMessage: onReceiveMessage)
    }
    
    func getAllMessages(completionHandler: @escaping GetAllMessageResponse) {
        let url = URL(string: "your_server_url")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"  // optional
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiClient.execute(request: request, completionHandler: completionHandler)
    }
}
