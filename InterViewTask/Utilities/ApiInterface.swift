//
//  ApiInterface.swift
//  InterViewTask
//
//  Created by TalentMicro on 19/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidBody
    case invalidEndpoint
    case invalidURL
    case emptyData
    case invalidJSON
    case invalidResponse
    case statusCode(Int)
}

 

import Foundation
 

class ApiPublishers {
    typealias completionHandeler = (Data?, URLResponse?, Error?) -> Void
    
    static func api(url:String,completion: @escaping completionHandeler)  {
        
        guard let url = URL(string: url ) else {
            return completion(nil,nil,APIError.invalidEndpoint)
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: .infinity)
        request.httpMethod = "GET"
         
        let dataTask = URLSession.shared.dataTask(with:request, completionHandler: completion)
        dataTask.resume()
        
    }
     
}
