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
    
    @State var noNewOrderRequestAbnormalitiesCount = 0
    @State var multipleExecutionsAbnormalitiesCount = 0
    @State var cancelledAfterExecutionAbnormalitiesCount = 0

    @State var transactionCounts = [Double]()

    var body: some View {
        ScrollView{
            VStack(alignment: .center) {
                    VStack(alignment: .leading){
                        Text("Status Summary")
                            .font(.title)
                            .fontWeight(.bold)
                        MyPieChart(demoData: $transactionCounts, titles: ["Successful", "Cancel"])
                    }
                    .modifier(CardModifier())

                
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        Text("Abnormal Types")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink {
                            tableView(items: $abnormalities)
                        } label: {
                            Text("View table")
                        }
                        
                    }
                    
                    
//                    BarChartView(data: ChartData(values: [(AbnormailityType.NoNewOrderRequest.rawValue, noNewOrderRequestAbnormalitiesCount), (AbnormailityType.MultipleExecutions.rawValue, multipleExecutionsAbnormalitiesCount), (AbnormailityType.CancelledAfterExecution.rawValue, cancelledAfterExecutionAbnormalitiesCount)]), title: "", form: ChartForm.large)
                    
                }
                .modifier(CardModifier())
                
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

                var executions = blocks.compactMap({$0.executions})
                var cancellations = blocks.compactMap({$0.cancellations})

                executions = executions.count > 100 ? executions.suffix(100) : executions
                cancellations = cancellations.count > 100 ? cancellations.suffix(100) : cancellations

                transactionCounts = [Double(executions.reduce(0, +)), Double(cancellations.reduce(0, +))]
                
                noNewOrderRequestAbnormalitiesCount = block.abnormalities.filter({$0.abnormailityType == .NoNewOrderRequest}).count
                multipleExecutionsAbnormalitiesCount = block.abnormalities.filter({$0.abnormailityType == .MultipleExecutions}).count
                cancelledAfterExecutionAbnormalitiesCount = block.abnormalities.filter({$0.abnormailityType == .CancelledAfterExecution}).count
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
