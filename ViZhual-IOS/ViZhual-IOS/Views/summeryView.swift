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
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var blocks = [Block]()
    @State var abnormalities = [Order]()
    @State var averageOrderLifes: [Double] = [0]
    
    @State var transactionNames = [String]()
    @State var transactionValues = [Double]()
    @State var transactionColors = [Color]()
    @State var barChartData = [(String, Double, Color)]()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                VStack {
                    VStack(alignment: .leading){
                        HStack(alignment: .center){
                            Text("Average Lifetime")
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
                    .padding([.leading, .trailing, .top], 16)
                    
                    
                    VStack(alignment: .leading){
                        Text("Status Summary")
                            .font(.title)
                            .fontWeight(.bold)
                        PieChartView(values: [12, 13], names: ["S", "SS"], formatter: { _ in
                            return "FUCK SWIFT"
                        }, colors: [.orange, .red], backgroundColor: .clear)
                            .frame(height: 300,alignment: .center)
                    }
                    .modifier(CardModifier())
                    .padding([.leading, .trailing], 16)
                    
                    VStack(alignment: .center){
                        HStack(alignment: .center){
                            Text("Abnormal Types")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            NavigationLink {
                                tableView(items: $abnormalities)
                            } label: {
                                Text("View Table")
                            }
                        }
                        
                        BarChart(data: $barChartData)
                            .frame(maxWidth: UIScreen.main.bounds.width - 32)
                    }
                    .modifier(CardModifier())
                    .padding([.leading, .trailing, .bottom], 16)
                }
            }
            .onReceive(timer) { _ in
                callAPI()
            }
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
                abnormalities = abnormalities.filter({$0.abnormailityType != .CancelledAfterExecution})
                averageOrderLifes = blocks.compactMap({$0.averageOrderLife})
                
                var executions = blocks.compactMap({$0.executions})
                var cancellations = blocks.compactMap({$0.cancellations})
                
                executions = executions.count > 100 ? executions.suffix(100) : executions
                cancellations = cancellations.count > 100 ? cancellations.suffix(100) : cancellations
                
                transactionNames = ["Successful", "Cancel"]
                transactionValues = [Double(executions.reduce(0, +)), Double(cancellations.reduce(0, +))]
                transactionColors = [.green, .orange]
                
                
                var noNewOrderRequestAbnormalities = abnormalities.filter({$0.abnormailityType == .NoNewOrderRequest})
                noNewOrderRequestAbnormalities = noNewOrderRequestAbnormalities.count > 100 ? noNewOrderRequestAbnormalities.suffix(100) : noNewOrderRequestAbnormalities
                let noNewOrderRequestAbnormalitiesCount = Double(noNewOrderRequestAbnormalities.count)
                
                var multipleExecutionsAbnormalities = abnormalities.filter({$0.abnormailityType == .MultipleExecutions})
                multipleExecutionsAbnormalities = multipleExecutionsAbnormalities.count > 100 ? multipleExecutionsAbnormalities.suffix(100) : multipleExecutionsAbnormalities
                let multipleExecutionsAbnormalitiesCount = Double(multipleExecutionsAbnormalities.count)
                
                
                barChartData = [(AbnormailityType.NoNewOrderRequest.value, noNewOrderRequestAbnormalitiesCount, AbnormailityType.NoNewOrderRequest.color), (AbnormailityType.MultipleExecutions.value, multipleExecutionsAbnormalitiesCount, AbnormailityType.MultipleExecutions.color)]
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
