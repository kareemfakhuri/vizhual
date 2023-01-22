//
//  summeryView.swift
//  FUCK
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI

struct summeryView: View {
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
                        Button {
                            
                        } label: {
                            Text("View table")
                        }
                        
                    }
                    MyPieChart()
                }
                .modifier(CardModifier())
                
                
                
                VStack(alignment: .leading){
                    MyLineView(title: "Average Life")
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
