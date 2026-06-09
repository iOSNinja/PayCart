//
//  PaymentMethod.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import UIKit

protocol PaymentMethod {
    var title: String { get }

    func pay(
        amount: Double,
        from viewController: UIViewController,
        completion: @escaping (PaymentStatus) -> Void
    )
}
