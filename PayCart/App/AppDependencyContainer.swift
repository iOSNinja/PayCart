//
//  AppDependencyContainer.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation
/* For production-quality architecture, we should avoid creating dependencies directly inside viewcontrollers' methods like didSelectRowAt. We can improve this using a Coordinator or AppDependencyContainer.
 
    A dependency container centralizes object creation. This keeps ViewControllers clean, reduces duplication, and makes it easier to switch implementations, such as using mock services in tests or different services for staging and production.
    So, instead of creating everything everywhere, we use a dependency container.
 */
final class AppDependencyContainer {
    private let apiClient: APIClientProtocol
    private let cartService: CartServiceProtocol
    
    private let paymentProcessor: PaymentProcessor
    private let paymentMethods: [PaymentMethod]
    
    init(
        apiClient: APIClientProtocol = APIClient(),
        cartService: CartServiceProtocol = CartService()
    ) {
        self.apiClient = apiClient
        self.cartService = cartService
        
        self.paymentProcessor = PaymentProcessor()

        self.paymentMethods = [
            ApplePayPayment(
                merchantIdentifier: "merchant.com.iosninja.paycart"
            ),
            CreditCardPayment(),
            PayPalPayment(),
            GiftCardPayment()
        ]
    }
    
    func makeProductRepository() -> ProductRepositoryProtocol {
        return ProductRepository(apiClient: apiClient)
    }
    
    func makeProductsViewController() -> ProductsViewController {
        let repository = makeProductRepository()
        let viewModel = ProductsViewModel(productRepository: repository)
        return ProductsViewController(viewModel: viewModel, dependencyContainer: self)
    }
    
    func makeProductDetailsViewController(productId: Int) -> ProductDetailsViewController {
        let repository = makeProductRepository()
        let viewModel = ProductDetailsViewModel(
            productId: productId,
            repository: repository,
            cartService: cartService
        )
        return ProductDetailsViewController(viewModel: viewModel, dependencyContainer: self)
    }
    
    func makeCartViewController() -> CartViewController {
        let viewModel = CartViewModel(cartService: cartService)

        return CartViewController(
            viewModel: viewModel,
            dependencyContainer: self
        )
    }
    
    func makeCheckoutViewController() -> CheckoutViewController {
        let viewModel = CheckoutViewModel(
            cartService: cartService,
            paymentProcessor: paymentProcessor,
            paymentMethods: paymentMethods
        )

        return CheckoutViewController(
            viewModel: viewModel,
            dependencyContainer: self
        )
    }
    
    func makeReceiptViewController(receipt: Receipt) -> ReceiptViewController {
        let viewModel = ReceiptViewModel(receipt: receipt)
        return ReceiptViewController(viewModel: viewModel)
    }
}
