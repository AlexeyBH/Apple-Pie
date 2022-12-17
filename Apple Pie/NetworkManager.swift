//
//  Network.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 14.11.2022.
//

import Foundation
import Alamofire

typealias Words = [String]


enum NetworkManagerError: Error {
    case connectionFailed
    case badServerData(AFError)
    case internalError(AFError)
}

class NetworkManager {
    
    let sourceSite = "https://random-word-api.herokuapp.com/all"
    
//    var closure: (Words) -> Void
    var words: Words = []
    
    static var shared = NetworkManager()
    
    func fetchWords() async -> [String] {
//        class TestReturn {
//            var words: Words! = nil
//            var error: AFError! = nil
//        }
        
//        let retn = TestReturn()
        
        let closure = () ->
        
        let result = AF.request(sourceSite).responseDecodable(of: Words.self)
        { response in
            // https://habr.com/ru/company/otus/blog/666436/
          // guard let self = self else { return }
            switch response.result {
            case .success(let value):
                return value
            case.failure(let error):
                retn.error = error
                
//                self.closure(words)
            }
        }
        
        return result
//        DispatchQueue.main.asyncAfter(deadline: .now() +) {
//            return retn.words
//        }
        
    }
    
    /*
    
    https://stackoverflow.com/questions/73806027/wait-for-closure-completion-to-make-a-synchronous-function-return
    */
    
    //throw NetworkManagerError.
    
    /*
     13
     URLSessionTask failed with error: The Internet connection appears to be offline.
     
     10
     Response could not be decoded because of error:
     The data couldn’t be read because it isn’t in the correct format.
     
     13
     URLSessionTask failed with error: unsupported URL
     
     */
    
//    let webView: WKWebView = WKWebView(frame: .zero)
//
//    static var shared = NetworkManager()
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript(
//            javaGetHTML,
//            completionHandler: { html, error in
//                guard let toBeParsed = html as? String else { return }
//                do {
//                    let document: Document = try SwiftSoup.parse(toBeParsed)
//                    print("Succesfully parsed!")
//                    print("outerHTML:")
//                    try print(document.outerHtml())
//
//
//                    print("ownText")
//                    try print(document.ownText())
//                    print("own text!!!")
//                    let r = try document.attr("Rand-stage")
//                    for i in r {
//                        print(i)
//                    }
//                } catch Exception.Error(_, let messaqge) {
//                    print(messaqge)
//                    return
//                } catch {
//                    print("General Error")
//                }
//
//            })
//    }
//
//        //webView(_:didFailProvisionalNavigation:withError:)
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        print("There is no internet or something...!")
//        print(error._code)
//        // -1009 no internet
//        print(error.localizedDescription)
//    }
//
//
//    func fetchData() {
//        guard let url = URL(string: sourceSite) else { return }
//        let request = URLRequest(url: url)
//        webView.navigationDelegate = self
//        webView.load(request)
//    }
    
}



