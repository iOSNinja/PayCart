//
//  ReceiptViewModel.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import Foundation

final class ReceiptViewModel {

    // MARK: - Dependency

    private let receipt: Receipt

    // MARK: - Init

    init(receipt: Receipt) {
        self.receipt = receipt
    }

    // MARK: - Display Text

    func titleText() -> String {
        return "Payment Successful"
    }

    func orderIdText() -> String {
        return "Order ID: \(receipt.orderId)"
    }

    func transactionIdText() -> String {
        return "Transaction ID: \(receipt.transactionId)"
    }

    func paymentMethodText() -> String {
        return "Payment Method: \(receipt.paymentMethod)"
    }

    func totalAmountText() -> String {
        return String(format: "Total Paid: $%.2f", receipt.totalAmount)
    }

    func itemCountText() -> String {
        let itemCount = receipt.items.reduce(0) { partialResult, cartItem in
            partialResult + cartItem.quantity
        }

        if itemCount == 1 {
            return "Items Purchased: 1"
        } else {
            return "Items Purchased: \(itemCount)"
        }
    }

    func dateText() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return "Date: \(formatter.string(from: receipt.date))"
    }
}
