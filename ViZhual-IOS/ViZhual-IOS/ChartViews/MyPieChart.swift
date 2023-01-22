//
//  MyPieChart.swift
//  Vizhual
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI
import SwiftUICharts

struct MyPieChart: View {
    @Binding var demoData: [Double]
    @State var titles = ["S1", "S2"]
    
    
    var body: some View {
        VStack(alignment: .center) {
            
            MyPieChartView(
                values: demoData,
                names: titles,
                formatter: {value in String(format: "%.2f", value)}, colors: [.green, .orange])
            .frame(height: 300,alignment: .center)
         }
    }
}

struct MyPieChart_Previews: PreviewProvider {
    static var previews: some View {
        MyPieChart(demoData: .constant([8, 12]))
    }
}
