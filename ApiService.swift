//
//  ApiService.swift
//  PNA
//
//  Created by AliPishvaee on 12/20/17.
//  Copyright © 2017 PNA. All rights reserved.
//

import UIKit


class ApiService: NSObject {
      
    func fetchGenericData <T: Decodable, S: Encodable>(url: String, encodedModel: S, completion : @escaping (T?,Error?) -> ()) {
        do {
            let jsonData = try JSONEncoder().encode(encodedModel.self)
            let url = URL(string: url)!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 60
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data , resp , error) in
                guard let data = data else { completion(nil,error); return }
                print(String(data: data, encoding: .utf8))
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    completion(obj,nil)
                } catch let jsonError {
                    completion(nil,jsonError); return }
                }.resume()
        } catch { completion(nil,error); return}
    }
}
