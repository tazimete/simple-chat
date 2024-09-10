//
//  ApiClient.swift
//  SampleChat
//
//  Created by AGM Tazim on 11/9/24.
//

import Foundation

typealias GetAllMessageResponse = (Result<[String], Error>)->Void

class ApiClient {
    static let shared = ApiClient()
    
    private init(){
        
    }
    
    func execute(request: URLRequest, completionHandler: @escaping GetAllMessageResponse) {
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print("Error while fetching data:", error)
                return
            }

            guard let data = data else {
                return
            }
            
            do {
                let messages = try JSONDecoder().decode([String].self, from: data)
                completionHandler(.success(messages))
            } catch let jsonError {
                print("Failed to decode json", jsonError)
                completionHandler(.failure(jsonError))
            }

        }
        
        task.resume()
    }
}
