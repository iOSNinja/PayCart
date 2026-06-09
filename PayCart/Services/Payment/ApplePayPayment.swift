//
//  ApplePayServiceProtocol.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import UIKit
import PassKit

final class ApplePayPayment: NSObject, PaymentMethod {

    let title = "Apple Pay"

    private let merchantIdentifier: String
    private var completion: ((PaymentStatus) -> Void)?

    init(merchantIdentifier: String) {
        self.merchantIdentifier = merchantIdentifier
    }

    func pay(
        amount: Double,
        from viewController: UIViewController,
        completion: @escaping (PaymentStatus) -> Void
    ) {
        self.completion = completion

        guard PKPaymentAuthorizationViewController.canMakePayments() else {
            completion(.failure(message: "Apple Pay is not available."))
            return
        }

        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantIdentifier
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.supportedNetworks = [.visa, .masterCard, .amex, .discover]
        request.merchantCapabilities = .threeDSecure

        request.paymentSummaryItems = [
            PKPaymentSummaryItem(
                label: "PayCart",
                amount: NSDecimalNumber(value: amount)
            )
        ]

        guard let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
            completion(.failure(message: "Unable to open Apple Pay."))
            return
        }

        applePayVC.delegate = self
        viewController.present(applePayVC, animated: true)
    }
}

extension ApplePayPayment: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        /*
         Production:
         Send payment.token.paymentData to backend/payment processor.

         Demo:
         Mock backend success.
        */

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let transactionId = "APPLE-PAY-MOCK-\(UUID().uuidString)"

            completion(
                PKPaymentAuthorizationResult(
                    status: .success,
                    errors: nil
                )
            )

            self?.completion?(
                .success(transactionId: transactionId)
            )
        }
    }

    func paymentAuthorizationViewControllerDidFinish(
        _ controller: PKPaymentAuthorizationViewController
    ) {
        controller.dismiss(animated: true)
    }
}


