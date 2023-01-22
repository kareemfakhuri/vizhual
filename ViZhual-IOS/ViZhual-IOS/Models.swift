//
//  Models.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/22/23.
//

import Foundation

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
}

struct Order: Codable {
    let orderID: String
    let status: OrderStatus
    let abnormailityType: AbnormailityType
    let timestamp: String
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
