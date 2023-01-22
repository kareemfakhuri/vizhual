//
//  summeryView.swift
//  FUCK
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI

struct summeryView: View {
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                VStack(alignment: .leading){
                    Text("Result")
                        .font(.title2)
                        .fontWeight(.semibold)
                    MyPieChart()
                }
                .modifier(CardModifier())
                
                VStack(alignment: .leading){
                    Text("Abnormal")
                        .font(.title2)
                        .fontWeight(.semibold)
                    MyPieChart()
                }
                .modifier(CardModifier())
            }
//            .frame(height: UIScreen.main.bounds.height)
            
            VStack(alignment: .leading){
                MyLineView(title: "Ave. life")
            }
            .modifier(CardModifier())
        }
        .padding()
    }
}

struct summeryView_Previews: PreviewProvider {
    static var previews: some View {
        summeryView()
    }
}
