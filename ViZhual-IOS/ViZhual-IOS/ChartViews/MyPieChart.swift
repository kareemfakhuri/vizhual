//
//  MyPieChart.swift
//  Vizhual
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI
import SwiftUICharts

struct MyPieChart: View {
    @State var demoData: [Double] = [8, 23]
    @State var count = 0
    @State var title1: String = "S1"
    @State var title2: String = "S2"

    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .center) {
            PieChartView(
                values: demoData,
                names: ["S1", "S2"],
                formatter: {value in String(format: "%.2f", value)})
            .frame(height: 300,alignment: .center)
         }
        .onReceive(timer) { _ in
            self.count += 1
            demoData = [Double.random(in: 1...20), Double.random(in: 1...20)]
            
            if count > 240 {
                timer.upstream.connect().cancel()
            }
        }
    }
}

struct MyPieChart_Previews: PreviewProvider {
    static var previews: some View {
        MyPieChart()
    }
}
