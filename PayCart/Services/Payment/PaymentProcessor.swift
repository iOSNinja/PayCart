//
//  PaymentProcessor.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import UIKit

final class PaymentProcessor {

    func pay(
        amount: Double,
        using method: PaymentMethod,
        from viewController: UIViewController,
        completion: @escaping (PaymentStatus) -> Void
    ) {
        method.pay(
            amount: amount,
            from: viewController,
            completion: completion
        )
    }
}
