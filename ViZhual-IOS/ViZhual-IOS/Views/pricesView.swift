//
//  pricesView.swift
//  FUCK
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI

struct pricesView: View {
    
    @State private var symbol = "I6SP5"
    @State private var priceLive = true
    @State private var demoData: [Double] = []
    
    // Create a Timer object with a 50ms interval
    var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .center){
            TextField("Enter the symbol", text: $symbol)
                .frame(height: 40)
                .padding(.horizontal, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .onChange(of: symbol, perform: { value in
                    symbol = symbol.uppercased()
                })
                .onSubmit {
                    
                    callAPI()
                }
            
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    Text(symbol)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Toggle("Live", isOn: $priceLive)
                        .toggleStyle(.button)
                                   .tint(.red)
                }
                MyLineView(live: priceLive, demoData: $demoData)
            }
            .modifier(CardModifier())
        }
        .padding()
        .onReceive(timer) { _ in
            callAPI()
        }
        
    }
    
    // Function to call the API web service
    func callAPI() {
        let url = URL(string: "http://localhost:3000/symbols/\(symbol)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let prices = try? JSONDecoder().decode(Prices.self, from: data)
            if let prices = prices {
                demoData = prices.compactMap({$0.price})
            }
        }
        
        task.resume()
    }
}

struct pricesView_Previews: PreviewProvider {
    static var previews: some View {
        pricesView()
    }
}
