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
    let javaGetHTML = "document.documentElement.outerHTML"
    let sourceSite = "https://www.randomlists.com/random-words"
    let webView: WKWebView = WKWebView(frame: .zero)
    
    static var shared = NetworkManager()
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(
            javaGetHTML,
            completionHandler: { html, error in
                guard let toBeParsed = html as? String else { return }
                do {
                    let document: Document = try SwiftSoup.parse(toBeParsed)
                    print("Succesfully parsed!")
                    print("outerHTML:")
                    try print(document.outerHtml())
                    
                    
                    print("ownText")
                    try print(document.ownText())
                    print("own text!!!")
                    let r = try document.attr("Rand-stage")
                    for i in r {
                        print(i)
                    }
                } catch Exception.Error(_, let messaqge) {
                    print(messaqge)
                    return
                } catch {
                    print("General Error")
                }
                
            })
    }
    
        //webView(_:didFailProvisionalNavigation:withError:)
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("There is no internet or something...!")
        print(error._code)
        // -1009 no internet
        print(error.localizedDescription)
    }
    
    
    func fetchData() {
        guard let url = URL(string: sourceSite) else { return }
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
    
}



