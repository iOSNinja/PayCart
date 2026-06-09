//
//  ProductDetailsViewModel.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

final class ProductDetailsViewModel {

    private let productId: Int
    private let repository: ProductRepositoryProtocol
    private let cartService: CartServiceProtocol

    private(set) var product: Product?

    var onProductLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onAddToCartSuccess: ((String) -> Void)?

    init(productId: Int,
         repository: ProductRepositoryProtocol,
         cartService: CartServiceProtocol
    ) {
        self.productId = productId
        self.repository = repository
        self.cartService = cartService
    }

    func loadProductDetails() {
        onLoadingChanged?(true)

        repository.fetchProductDetails(productId: productId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.onLoadingChanged?(false)

                switch result {
                case .success(let product):
                    self.product = product
                    self.onProductLoaded?()

                case .failure:
                    self.onError?("Unable to load product details.")
                }
            }
        }
    }
    
    func addToCart() {
        guard let product = self.product else {
            onError?("Product details are not loaded yet.")
            return
        }
        
        cartService.add(product: product)
        onAddToCartSuccess?("Added to cart.")
    }

    func titleText() -> String {
        return product?.title ?? ""
    }

    func priceText() -> String {
        guard let price = product?.price else { return "" }
        return "$\(price)"
    }

    func descriptionText() -> String {
        return product?.description ?? ""
    }
    
    func categoryText() -> String {
        return product?.category ?? ""
    }
}
