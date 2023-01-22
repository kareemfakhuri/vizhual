//
//  MyPieChart.swift
//  Vizhual
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI
import SwiftUICharts

struct MyPieChart: View {
    @State var demoData: [Int] = [8, 23]
    @State var titles = ["S1", "S2"]
    
    
    var body: some View {
        VStack(alignment: .center) {
            PieChartView(
                values: demoData,
                names: titles,
                formatter: {value in String(format: "%.2f", value)})
            .frame(height: 300,alignment: .center)
         }
    }
}

struct MyPieChart_Previews: PreviewProvider {
    static var previews: some View {
        MyPieChart()
    }
}
