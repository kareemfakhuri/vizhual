//
//  pricesView.swift
//  FUCK
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI

struct pricesView: View {
    @State private var selectedStrength = "Mild"
    let strengths = ["Mild", "Medium", "Mature"]
    
    var body: some View {
        VStack(alignment: .center){
            Picker("Strength", selection: $selectedStrength) {
                ForEach(strengths, id: \.self) {
                    Text($0)
                }
            }
            
            VStack(alignment: .leading){
                MyLineView(title: selectedStrength)
            }
            .modifier(CardModifier())
        }
        .padding()
        
    }
}

struct pricesView_Previews: PreviewProvider {
    static var previews: some View {
        pricesView()
    }
}
