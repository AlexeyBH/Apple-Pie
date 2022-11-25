//
//  Network.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 14.11.2022.
//

import Foundation
import SwiftSoup
import WebKit


class NetworkManager: NSObject, WKNavigationDelegate {
    let javeGetHTML = "document.documentElement.outerHTML"
    let url = "https://www.randomlists.com/random-words"
    let webView: WKWebView = WKWebView(frame: .zero)
    
    static var shared = NetworkManager()
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(
            javeGetHTML,
            completionHandler: { html, error in
                guard let toBeParsed = html as? String else { return }
                do {
                    let document: Document = try SwiftSoup.parse(toBeParsed)
                    print("Succesfully parsed!")
                    try print(data.text())
                } catch Exception.Error(_, let messaqge) {
                    print(messaqge)
                    return
                } catch {
                    print("General Error")
                }

            })
    }
    

   
    }


}
