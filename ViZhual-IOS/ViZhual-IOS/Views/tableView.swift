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
    
    @Binding var items: [Order]
    
    var body: some View {
        List {
            HStack {
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
            
            
            ForEach(items, id: \.orderID) { item in
                VStack {
                    Text(item.timestamp)
                        .minimumScaleFactor(0.9)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(8)
                    HStack {
                        Text(item.symbol)
                            .minimumScaleFactor(0.9)
                            .multilineTextAlignment(.center)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(8)
                        Text(item.abnormailityType.value)
                            .minimumScaleFactor(0.9)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .center)
                            .background(item.abnormailityType.color)
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
        tableView(items: .constant([Order(orderID: "kasfhsdkh", status: .Cancelled, abnormailityType: .NoNewOrderRequest, timestamp: "22:30", symbol: "APL", life: 12)]))
    }
}
