//
//  LineView.swift
//  Vizhual
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI
import SwiftUICharts

struct MyLineView: View {
    var title: String?
    var legend: String?
    
    @State var demoData: [Double] = []
    @State var count = 0
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
            VStack {
                LineView(data: demoData, title: title, legend: legend, style: Styles.lineChartStyleOne)
            }
            .onReceive(timer) { _ in
                self.count += 1
                demoData.append(Double.random(in: 1...20))
                
                if count > 240 {
                    timer.upstream.connect().cancel()
                }
            }
    }
}

struct MyLineView_Previews: PreviewProvider {
    static var previews: some View {
        MyLineView()
    }
}
