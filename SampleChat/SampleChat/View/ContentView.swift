//
//  ContentView.swift
//  SampleChat
//
//  Created by AGM Tazim on 10/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: MessageViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Simple Chat")
            }
            
            ScrollView(showsIndicators: true) {
                LazyVStack(alignment: .center) {
                    ForEach(viewModel.messageList, id: \.self){ item in
                        Text(item)
                    }
                }
            }
            
            HStack(alignment: .center) {
                TextField("Type here..",  text: $viewModel.message)
                    .padding(.all, 5)
                    .border(.gray, width: 1.0)
                    .cornerRadius(2.0)
                
                Button(action: {
                    viewModel.sendMessage()
                }, label: {
                    Text("Send")
                        .padding(.all, 5)
                        .border(.gray, width: 1.0)
                        .cornerRadius(2.0)
                })
            }
            
            
        }
        .padding()
        .onAppear{
            viewModel.receiveMessage()
            viewModel.getAllMessages()
        }
    }
}
