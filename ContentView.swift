//
//  ContentView.swift
//  SampleApp
//
//  Created by nokkun on 2022/09/06.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewmodel = ViewModel(url: "http://192.168.11.8:5000")
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    WebViewContainer(viewmodel: viewmodel)
                }
                if viewmodel.isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle(Text(viewmodel.title), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    viewmodel.shouldGoBack = true
                }) {
                    if viewmodel.canGoBack {
                        Text("<Back")
                    } else {
                        EmptyView()
                    }
                },
                trailing: Button(action: {
                    viewmodel.load("https://google.com")
                }) {
                    Text("Google")
                }
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

