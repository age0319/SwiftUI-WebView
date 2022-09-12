//
//  WebViewContainer.swift
//  SampleApp
//
//  Created by nokkun on 2022/09/07.
//

import Foundation
import SwiftUI
import WebKit

struct WebViewContainer: UIViewRepresentable {
    
    @ObservedObject var viewmodel: ViewModel
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, viewmodel: viewmodel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        // URLがnullだったらロードせずにリターン
        guard let url = URL(string: viewmodel.url) else {
              return WKWebView()
          }
        
        // Delegateの設定
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        // ページのロード
        let request = URLRequest(url: url)
        webView.load(request)
          
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if viewmodel.shouldGoBack {
           uiView.goBack()
           viewmodel.shouldGoBack = false
        }
        if viewmodel.shouldLoad {
           guard let url = URL(string: viewmodel.url) else {
               return
           }
           let request = URLRequest(url: url)
           uiView.load(request)
           viewmodel.shouldLoad = false
        }
    }
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if(message.name == "changeTextbox"){
                let param = message.body as! String
                print(param)
            }
        }
        
        @ObservedObject private var viewmodel: ViewModel
        var parent: WebViewContainer
        
        init(_ parent: WebViewContainer, viewmodel: ViewModel) {
            self.parent = parent
            self.viewmodel = viewmodel
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            viewmodel.isLoading = false
            viewmodel.title = webView.title ?? ""
            viewmodel.canGoBack = webView.canGoBack
//            webView.evaluateJavaScript("document.querySelector('.log3').innerHTML = 'hoge';document.querySelector('.log3').innerHTML;")
            
            webView.evaluateJavaScript("const email = document.querySelector('#email');                                       email.addEventListener('input', {outputname: '.log',handleEvent:handleChange});const pass = document.querySelector('#pass');pass.addEventListener('input', {outputname: '.log2',handleEvent:handleChange});                                       function handleChange(event){                                           const value = event.target.value;                                           document.querySelector(this.outputname).innerHTML = value;                                           webkit.messageHandlers.changeTextbox.postMessage(value)}")
            webView.configuration.userContentController.add(self, name: "changeTextbox")
        }
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            print(message)
            completionHandler()
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            viewmodel.isLoading = true
        }
               
           
       func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
           viewmodel.isLoading = false
           setError(error)
       }
           
       func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
           viewmodel.isLoading = false
           setError(error)
       }
           
       private func setError(_ error: Error) {
           if let error = error as? URLError {
               viewmodel.error = ViewModel.Error(code: error.code, message: error.localizedDescription)
           }
       }
        
    }
    
}
