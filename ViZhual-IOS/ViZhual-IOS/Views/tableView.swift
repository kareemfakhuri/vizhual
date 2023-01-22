//
//  tableView.swift
//  FUCK
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI

struct Item: Identifiable {
    var id: String { symbol }
    let price: Double
    let symbol: String
    let time: String
    let type: String
}



struct tableView: View {
    
    let items = [
        Item(price: 2.07, symbol: "APL", time: "2023-06-02 12:23:34", type: "MT"),
        Item(price: 2.07, symbol: "NHL", time: "2023-06-02 12:23:34", type: "NNR"),
        Item(price: 2.07, symbol: "PSI", time: "2023-06-02 12:23:34", type: "MT"),
        Item(price: 2.07, symbol: "TSN", time: "2023-06-02 12:23:34", type: "MT"),
        Item(price: 2.07, symbol: "MSK", time: "2023-06-02 12:23:34", type: "NNR"),
        Item(price: 2.07, symbol: "MSN", time: "2023-06-02 12:23:34", type: "MT")
    ]
    
    var body: some View {
        List {
            HStack {
                Text("Price")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                    .background(Color.gray)
                    .cornerRadius(8)
                Text("Symbol")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                    .background(Color.gray)
                    .cornerRadius(8)
                Text("Type")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                    .background(Color.gray)
                    .cornerRadius(8)
            }
            .shadow(radius: 2)
            
            
            ForEach(items, id: \.id) { item in
                VStack {
                    Text(item.time)
                        .minimumScaleFactor(0.9)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(8)
                    HStack {
                        Text("\(item.price)")
                            .minimumScaleFactor(0.9)
                            .multilineTextAlignment(.center)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(8)
                        Text(item.symbol)
                            .minimumScaleFactor(0.9)
                            .multilineTextAlignment(.center)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(8)
                        Text(item.type)
                            .minimumScaleFactor(0.9)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }
                .shadow(radius: 2)
            }
        }
    }
}

struct tableView_Previews: PreviewProvider {
    static var previews: some View {
        tableView()
    }
}
