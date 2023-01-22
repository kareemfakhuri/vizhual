//
//  ContentView.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            summeryView()
                .tabItem {
                    Label("Summery", systemImage: "chart.pie.fill")
                }
            
            pricesView()
                .tabItem {
                    Label("Prices", systemImage: "dollarsign.circle.fill")
                }
        }
        .accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
