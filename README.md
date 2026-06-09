# PayCart

PayCart is a demo iOS shopping and payments app built to practice and demonstrate clean iOS architecture, MVVM, dependency injection, cart management, checkout flow, and Apple Pay integration.

The app shows a list of products, allows users to view product details, add items to a cart, proceed to checkout, select a payment method, complete payment using a real Apple Pay sheet, and view a receipt.

## Features

* Product listing using remote API data
* Product details screen
* Add to cart functionality
* Shared cart state across screens
* Cart screen with item quantity management
* Checkout screen
* Payment method selection
* Apple Pay integration using PassKit
* Real Apple Pay authorization sheet
* Mocked backend/payment authorization response
* Receipt screen after successful payment
* App icon and launch screen support
* Programmatic UIKit layout
* MVVM architecture
* Dependency Injection
* Open/Closed Principle-based payment design

## Screenshots

For UI screenshots, [click here](Screenshots).

## Architecture

PayCart uses a layered MVVM architecture:

```text
ViewController
    ↓
ViewModel
    ↓
Repository / Service
    ↓
APIClient
    ↓
URLSession
```

For local business logic, the app uses services:

```text
CartViewController
    ↓
CartViewModel
    ↓
CartService
```

For product data, the app uses a repository:

```text
ProductsViewController
    ↓
ProductsViewModel
    ↓
ProductRepository
    ↓
APIClient
    ↓
URLSession
```

## Key Design Principles

### MVVM

ViewControllers are responsible for UI rendering and user interaction.

ViewModels are responsible for presentation logic, validation, formatting, and calling repositories or services.

### Dependency Injection

Dependencies are injected through initializers instead of being created directly inside ViewModels or ViewControllers.

This makes the app easier to test, maintain, and extend.

### Repository Pattern

Repositories handle data access.

Example:

```text
ProductRepository
```

is responsible for fetching product list and product details from the API.

### Services

Services handle business logic or platform-specific operations.

Examples:

```text
CartService
ApplePayPayment
PaymentProcessor
```

### Open/Closed Principle for Payments

Payment methods are modeled using a protocol-based strategy design.

Instead of using large `if/else` or `switch` logic, each payment method owns its own implementation.

```swift
protocol PaymentMethod {
    var title: String { get }

    func pay(
        amount: Double,
        from viewController: UIViewController,
        completion: @escaping (PaymentStatus) -> Void
    )
}
```

Current payment implementations:

```text
ApplePayPayment
CreditCardPayment
PayPalPayment
```

Apple Pay is implemented now. Credit Card and PayPal are placeholders for future extension.

Adding a new payment method only requires creating a new class that conforms to `PaymentMethod`.

## Apple Pay Flow

PayCart presents the real Apple Pay payment sheet using PassKit.

Current demo flow:

```text
User taps Pay with Apple Pay
    ↓
Apple Pay sheet is presented
    ↓
User authorizes payment
    ↓
App receives PKPayment
    ↓
App mocks backend/payment gateway authorization
    ↓
Apple Pay sheet receives success
    ↓
Receipt screen is shown
```

Production flow would replace the mocked backend response with a real backend/payment processor call.

```text
PKPayment token
    ↓
Backend
    ↓
Payment Processor
    ↓
Authorization/Capture
    ↓
Result returned to app
```

The app does not store or process raw card details.

## Project Structure

```text
PayCart
│
├── App
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppDependencyContainer.swift
│
├── Core
│   ├── Network
│   ├── Utilities
│   └── Constants
│
├── Models
│   ├── Product.swift
│   ├── CartItem.swift
│   ├── Receipt.swift
│   └── PaymentStatus.swift
│
├── Repositories
│   ├── ProductRepositoryProtocol.swift
│   └── ProductRepository.swift
│
├── Services
│   ├── Cart
│   │   ├── CartServiceProtocol.swift
│   │   └── CartService.swift
│   │
│   └── Payment
│       ├── PaymentMethod.swift
│       ├── PaymentProcessor.swift
│       ├── ApplePayPayment.swift
│       ├── CreditCardPayment.swift
│       └── PayPalPayment.swift
│
├── Features
│   ├── ProductsList
│   ├── ProductDetails
│   ├── Cart
│   ├── Checkout
│   └── Receipt
│
└── Resources
    ├── Assets.xcassets
    └── LaunchScreen.storyboard
```

## Main App Flow

```text
Products List
    ↓
Product Details
    ↓
Add to Cart
    ↓
Cart
    ↓
Checkout
    ↓
Apple Pay
    ↓
Receipt
```

## Apple Pay Setup

To run the Apple Pay flow on a real device:

1. Create a Merchant ID in the Apple Developer portal.
2. Enable Apple Pay for the app identifier.
3. Add Apple Pay capability in Xcode.
4. Add the Merchant ID to the app target.
5. Make sure the Merchant ID in code matches the one configured in Xcode.
6. Run the app on a real iPhone.
7. Use a Wallet card or Apple Pay sandbox test card.

Example merchant identifier:

```swift
merchant.com.ravi.paycart
```

Update this value in:

```swift
ApplePayPayment(
    merchantIdentifier: "merchant.com.ravi.paycart"
)
```

## Technologies Used

* Swift
* UIKit
* PassKit
* URLSession
* MVVM
* Dependency Injection
* Repository Pattern
* Strategy Pattern
* Open/Closed Principle
* Programmatic Auto Layout

## Current Payment Support

| Payment Method | Status                                       |
| -------------- | -------------------------------------------- |
| Apple Pay      | Real Apple Pay sheet + mock backend response |
| Credit Card    | Placeholder                                  |
| PayPal         | Placeholder                                  |


This project demonstrates:

* How to separate UI from business logic using MVVM
* How to use dependency injection for testability
* How to use repositories for API/data access
* How to use services for business logic
* How to design a payment flow using the Open/Closed Principle
* How to integrate Apple Pay using PassKit
* How to mock backend payment authorization while still showing the real Apple Pay sheet
* How to keep checkout independent from specific payment implementations

## Notes

The Apple Pay sheet is real, but the payment authorization result is mocked for demo purposes. No real backend or production payment processor is used.

