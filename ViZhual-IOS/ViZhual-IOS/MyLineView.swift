//
//  LineView.swift
//  Vizhual
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI
import SwiftUICharts

struct MyLineView: View {
    @State var demoData: [Double] = []
    @State var count = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
            VStack {
                LineView(data: demoData, title: "Line", legend: "Full screen", style: Styles.lineChartStyleOne)
                    .animation(.linear(duration: 1), value: count)
            }
            .padding()
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
