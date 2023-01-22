//
//  MultiLineChartView.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/22/23.
//

import SwiftUI
import Charts

struct AbnormalData: Identifiable, Hashable {
    var id = UUID()
    var abnormalType: String
    var value: Int
}
