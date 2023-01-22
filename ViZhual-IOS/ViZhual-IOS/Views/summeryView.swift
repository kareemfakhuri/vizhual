//
//  summeryView.swift
//  FUCK
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI
import SwiftUICharts

struct summeryView: View {
    @State private var lifetimeLive = true
    
    // Create a Timer object with a 50ms interval
    var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var blocks = [Block]()
    @State var abnormalities = [Order]()
    @State var executions = 0
    @State var cancelations = 0
    @State var averageOrderLifes = [Double]()

    var body: some View {
        ScrollView{
            VStack(alignment: .center) {
                VStack(alignment: .leading){
                    Text("Status Summary")
                        .font(.title)
                        .fontWeight(.bold)
                    MyPieChart(demoData: [executions, blocks.first?.cancellations ?? 12, abnormalities.count], titles: ["Successful", "Cancel", "Abnormal"])
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
                    BarChartView(data: ChartData(values: [("", 89), ("", 89), ("", 89)]), title: "")
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
                    MyLineView(live: lifetimeLive, demoData: $averageOrderLifes)
                }
                .modifier(CardModifier())
            }
            .padding()
        }
        .onReceive(timer) { _ in
            callAPI()
        }
    }
    
    // Function to call the API web service
    func callAPI() {
        let url = URL(string: "http://localhost:3000/last-block")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let block = try? JSONDecoder().decode(Block.self, from: data)
            if let block = block {
                print(block)
                blocks.append(block)
                abnormalities += block.abnormalities
                averageOrderLifes = blocks.compactMap({$0.averageOrderLife})
                executions = blocks.compactMap({$0.executions}).reduce(0, +)
                cancelations = blocks.compactMap({$0.cancellations}).reduce(0, +)
            }
        }
        
        task.resume()
    }
}

struct summeryView_Previews: PreviewProvider {
    static var previews: some View {
        summeryView()
    }
}
