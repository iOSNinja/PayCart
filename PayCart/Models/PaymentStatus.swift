//
//  PaymentStatus.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

enum PaymentStatus {
    case success(transactionId: String)
    case failure(message: String)
}
