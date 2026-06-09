//
//  GiftCardPayment.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/17/26.
//

import UIKit

final class GiftCardPayment: PaymentMethod {
    let title = "Gift Card"

    func pay(
        amount: Double,
        from viewController: UIViewController,
        completion: @escaping (PaymentStatus) -> Void
    ) {
        // gift card logic
        completion(
            .failure(message: "Gift Card payment is not implemented yet.")
        )
    }
}
