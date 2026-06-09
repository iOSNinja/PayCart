//
//  CheckoutViewModel.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import UIKit

final class CheckoutViewModel {

    // MARK: - Dependencies

    private let cartService: CartServiceProtocol
    private let paymentProcessor: PaymentProcessor
    private let paymentMethods: [PaymentMethod]

    // MARK: - State

    private var selectedPaymentMethod: PaymentMethod
    private var isPaymentInProgress = false

    // MARK: - Output Closures

    var onPaymentStarted: (() -> Void)?
    var onPaymentFinished: (() -> Void)?
    var onPaymentSuccess: ((Receipt) -> Void)?
    var onPaymentFailure: ((String) -> Void)?

    // MARK: - Init

    init(
        cartService: CartServiceProtocol,
        paymentProcessor: PaymentProcessor,
        paymentMethods: [PaymentMethod]
    ) {
        self.cartService = cartService
        self.paymentProcessor = paymentProcessor
        self.paymentMethods = paymentMethods

        let defaultIndex = paymentMethods.firstIndex { paymentMethod in
            paymentMethod is ApplePayPayment
        } ?? 0

        self.selectedPaymentMethod = paymentMethods[defaultIndex]
    }

    // MARK: - Payment Method Display

    func numberOfPaymentMethods() -> Int {
        return paymentMethods.count
    }

    func paymentMethodTitle(at index: Int) -> String {
        guard paymentMethods.indices.contains(index) else {
            return ""
        }

        return paymentMethods[index].title
    }

    func defaultPaymentMethodIndex() -> Int {
        return paymentMethods.firstIndex { paymentMethod in
            paymentMethod is ApplePayPayment
        } ?? 0
    }

    func selectPaymentMethod(at index: Int) {
        guard paymentMethods.indices.contains(index) else {
            return
        }

        selectedPaymentMethod = paymentMethods[index]
    }

    func selectedPaymentMethodTitle() -> String {
        return selectedPaymentMethod.title
    }

    // MARK: - Cart Summary

    func totalAmountText() -> String {
        return String(format: "Total: $%.2f", cartService.totalAmount())
    }

    func itemCountText() -> String {
        let count = cartService.items.reduce(0) { partialResult, item in
            partialResult + item.quantity
        }

        if count == 1 {
            return "Items: 1"
        } else {
            return "Items: \(count)"
        }
    }

    // MARK: - Checkout

    func checkout(from viewController: UIViewController) {
        guard !isPaymentInProgress else {
            return
        }

        let amount = cartService.totalAmount()

        guard amount > 0 else {
            onPaymentFailure?("Cart is empty.")
            return
        }

        isPaymentInProgress = true
        onPaymentStarted?()

        paymentProcessor.pay(
            amount: amount,
            using: selectedPaymentMethod,
            from: viewController
        ) { [weak self] status in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }

                self.isPaymentInProgress = false
                self.onPaymentFinished?()

                switch status {
                case .success(let transactionId):
                    let receipt = Receipt(
                        orderId: UUID().uuidString,
                        transactionId: transactionId,
                        items: self.cartService.items,
                        totalAmount: amount,
                        paymentMethod: self.selectedPaymentMethod.title,
                        date: Date()
                    )

                    self.cartService.clearCart()
                    self.onPaymentSuccess?(receipt)

                case .failure(let message):
                    self.onPaymentFailure?(message)
                }
            }
        }
    }
}
