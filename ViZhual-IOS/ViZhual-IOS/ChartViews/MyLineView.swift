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
    var limit = 100

    @Binding var demoData: [Double]
    
    var body: some View {
        VStack {
            if !live {
                LineView(data: demoData, title: title, legend: legend, style: Styles.lineChartStyleOne)
                    .frame(height: 350)
            } else {
                LineView(data: demoData.count > limit ? demoData.suffix(limit) : demoData, title: title, legend: legend, style: Styles.lineChartStyleOne)
                    .frame(height: 350)
            }
        }
    }
}

struct MyLineView_Previews: PreviewProvider {
    static var previews: some View {
        MyLineView(demoData: .constant([]))
    }
}
