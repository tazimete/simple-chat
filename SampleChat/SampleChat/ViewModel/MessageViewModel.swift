//
//  MessageViewModel.swift
//  SampleChat
//
//  Created by AGM Tazim on 11/9/24.
//

import Foundation
import SwiftUI

class MessageViewModel: ObservableObject {
    let repository: MessageRepository
    
    @Published var messageList = [String]()
    @Published var message = ""
    
    init(repository: MessageRepository) {
        self.repository = repository
    }
    
    //MARK: Socket Call
    func sendMessage() {
        messageList.append(message)
        repository.postMessage(message: message)
        message = ""
    }
    
    func receiveMessage() {
        repository.receiveMessage(
            onReceiveMessage: { [weak self] message in
                self?.messageList.append(message)
            }
        )
    }
    
    
    //MARK: Network/API Call
    func getAllMessages() {
        repository.getAllMessages(completionHandler: { [weak self] result in
            switch(result) {
            case .success(let messages):
                self?.messageList = messages
                break
                
            case .failure(let error):
                print("Error from server = \(error)")
                break 
            }
        })
    }
}
