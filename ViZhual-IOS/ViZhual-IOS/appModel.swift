//
//  appModel.swift
//  ViZhual-IOS
//
//  Created by Soro on 2023-01-21.
//

import Foundation


class Vizhual : ObservableObject {
    @Published private(set) var time: String = ""
    
    func updateTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dateString = formatter.string(from: Date())
        time = dateString
    }
}
