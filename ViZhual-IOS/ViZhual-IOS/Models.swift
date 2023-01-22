//
//  Models.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/22/23.
//

import SwiftUI

// Codable model
enum OrderStatus: String, Codable {
    case Unresolved = "Unresolved"
    case Cancelled = "Cancelled"
    case Executed = "Executed"
}

enum AbnormailityType: String, Codable {
    case None = "None"
    case NoNewOrderRequest = "NoNewOrderRequest"
    case MultipleExecutions = "MultipleExecutions"
    case CancelledAfterExecution = "CancelledAfterExecution"
    
    var value: String {
        switch self {
        case .None:
            return "?"
        case .NoNewOrderRequest:
            return "No Request"
        case .MultipleExecutions:
            return "Duplicate Trade"
        case .CancelledAfterExecution:
            return "Cancel After Trade"
        }
    }
    
    var color: Color {
        switch self {
        case .None:
            return .gray
        case .NoNewOrderRequest:
            return .orange
        case .MultipleExecutions:
            return .red
        case .CancelledAfterExecution:
            return .blue
        }
    }
}

struct Order: Codable {
    let orderID: String
    let status: OrderStatus
    let abnormailityType: AbnormailityType
    let timestamp: String
    let symbol: String
    let life: Int
}

struct Block: Codable {
    let timestamp: String
    let executions: Int
    let cancellations: Int
    let abnormalities: [Order]
    let averageOrderLife: Double
}

// MARK: - Price
struct Price: Codable {
    let orderID, direction, type: String
    let timestamp: Double
    let symbol: String
    let price: Double
}

typealias Prices = [Price]
