//
//  ContentView.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView{
                summeryView()
                    .tabItem {
                        Label("Summery", systemImage: "chart.pie.fill")
                    }
                
                pricesView()
                    .tabItem {
                        Label("Prices", systemImage: "dollarsign.circle.fill")
                    }
                
                pricesView()
                    .tabItem {
                        Label("Security", systemImage: "key.icloud")
                    }
            }
            .navigationViewStyle(.automatic)
            .accentColor(.red)
            .navigationTitle("Vizhual")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
