//
//  ViewModel.swift
//  SampleApp
//
//  Created by nokkun on 2022/09/07.
//

import Foundation

class ViewModel: ObservableObject{
    
    @Published var isLoading = false
    @Published var canGoBack = false
    @Published var shouldGoBack = false
    @Published var shouldLoad = false
    @Published var title = ""

    struct Error {
        let code: URLError.Code
        let message: String
    }
    @Published var error: Error?
    
    private(set) var url: String
    
    init(url: String) {
        self.url = url
    }

    func load(_ url: String) {
        self.url = url
        shouldLoad = true
    }

}
