//
//  BarChartView.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/22/23.
//

import SwiftUI

struct BarChart: View {
    @Binding var data: [(String, Double, Color)]

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                ForEach(data, id: \.0) { item in
                    Text(item.0)
                        .padding(10)
                }
            }
            
            VStack(alignment: .leading) {
                ForEach(data, id: \.0) { item in
                    BarView(value: item.1, color: item.2)
                        .padding(5)
                }
            }
            Spacer()
        }
        .padding(10)
    }
}

struct BarView: View {
    var value: Double
    var color: Color

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: min(UIScreen.main.bounds.width - 200 ,CGFloat(value) * 10), height: 30)
                .foregroundColor(color)
            
            Text("\(Int(value))")
                .foregroundColor(.black)
                .padding(.leading, 10)
        }
    }
}
