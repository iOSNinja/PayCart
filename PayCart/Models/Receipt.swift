//
//  Receipt.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

struct Receipt {
    let orderId: String
    let transactionId: String
    let items: [CartItem]
    let totalAmount: Double
    let paymentMethod: String
    let date: Date
}
