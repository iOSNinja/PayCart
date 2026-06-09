//
//  CreditCardPayment.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import UIKit

final class CreditCardPayment: PaymentMethod {

    let title = "Credit Card"

    func pay(
        amount: Double,
        from viewController: UIViewController,
        completion: @escaping (PaymentStatus) -> Void
    ) {
        completion(
            .failure(message: "Credit Card payment is not implemented yet.")
        )
    }
}
