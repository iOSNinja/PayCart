//
//  PayPalPayment.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import UIKit

final class PayPalPayment: PaymentMethod {

    let title = "PayPal"

    func pay(
        amount: Double,
        from viewController: UIViewController,
        completion: @escaping (PaymentStatus) -> Void
    ) {
        completion(
            .failure(message: "PayPal payment is not implemented yet.")
        )
    }
}
