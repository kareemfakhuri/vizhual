//
//  pricesView.swift
//  FUCK
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI

struct pricesView: View {
    let strengths = ["Mild", "Medium", "Mature"]
    
    @State private var selectedStrength = "Mild"
    @State private var priceLive = true
    
    var body: some View {
        VStack(alignment: .center){
            Picker("Strength", selection: $selectedStrength) {
                ForEach(strengths, id: \.self) {
                    Text($0)
                }
            }
            
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    Text(selectedStrength)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Toggle("Live", isOn: $priceLive)
                        .toggleStyle(.button)
                                   .tint(.red)
                }
                MyLineView(live: priceLive)
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
