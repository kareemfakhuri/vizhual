//
//  ContentView.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MyPieChart()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
