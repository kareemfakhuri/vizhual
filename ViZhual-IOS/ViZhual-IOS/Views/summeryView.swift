//
//  summeryView.swift
//  FUCK
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI

struct summeryView: View {
    @State private var lifetimeLive = false
    var body: some View {
        ScrollView{
            VStack(alignment: .center) {                    VStack(alignment: .leading){
                Text("Summery")
                    .font(.title)
                    .fontWeight(.bold)
                    MyPieChart()
                
            }
            .modifier(CardModifier())
                
                
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        Text("Abnormal")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink {
                            tableView()
                        } label: {
                            Text("View table")
                        }
                        
                    }
                    MyPieChart()
                }
                .modifier(CardModifier())
                
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        Text("Average lifetime")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Toggle("Live", isOn: $lifetimeLive)
                            .toggleStyle(.button)
                                       .tint(.red)
                    }
                    MyLineView(live: lifetimeLive)
                }
                .modifier(CardModifier())
            }
            .padding()
        }
    }
}

struct summeryView_Previews: PreviewProvider {
    static var previews: some View {
        summeryView()
    }
}
