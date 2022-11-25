//
//  Network.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 14.11.2022.
//

import Foundation
import SwiftSoup


struct NetworkManager {
    
    let url: String = ""
    
    static var shared = NetworkManager()
    
    func fetchData() {
        let url = URL(string: "https://www.randomlists.com/random-words")
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(
            with: request,
            completionHandler: {
                (data: Data?, response: URLResponse?, error) in
                do {
                    guard let dec = data else {
                        print("No data!")
                        return
                    }
                    let html = String(decoding: dec, as: UTF8.self)
                    print("fetched:")
                    print(html)
                    let doc: Document = try SwiftSoup.parse(html)
                    print("decoded:")
                    try print(doc.text())
                } catch Exception.Error( _, let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }
        ).resume()
        
 
        
        
  
   
    }

    private init() {

    }
}
