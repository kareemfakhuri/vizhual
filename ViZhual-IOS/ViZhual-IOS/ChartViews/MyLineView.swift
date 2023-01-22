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
    var live: Bool = false
    
    @State var demoData: [Double] = []
    @State var count = 0
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
            VStack {
                if !live{
                    LineView(data: demoData, title: title, legend: legend, style: Styles.lineChartStyleOne)
                        .frame(height: 350)
                }else{
                    LineView(data: demoData.count > 20 ? demoData.suffix(20) : demoData, title: title, legend: legend, style: Styles.lineChartStyleOne)
                        .frame(height: 350)
                }

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
