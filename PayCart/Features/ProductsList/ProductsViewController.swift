//
//  ProductsViewController.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation
import UIKit

final class ProductsViewController: UIViewController {
    private let viewModel: ProductsViewModel
    private let dependencyContainer: AppDependencyContainer
    private let tableView = UITableView()
    
    init(viewModel: ProductsViewModel,
         dependencyContainer: AppDependencyContainer) {
        self.viewModel = viewModel
        self.dependencyContainer = dependencyContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products"
        view.backgroundColor = .white
        
        setupTableView()
        setupNavigationBar()
        bindViewModel()
        
        viewModel.loadProducts()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
    }
    
    private func bindViewModel() {
        viewModel.onProductsLoaded = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message: message)
        }
        
        viewModel.onLoadingChanged = { isLoading in
            print("isLoading: \(isLoading)")
        }
        
        viewModel.onProductSelected = { [weak self] productId in
            if let detailsVC = self?.dependencyContainer.makeProductDetailsViewController(productId: productId) {
                self?.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let product = viewModel.product(at: indexPath.row)
        cell.textLabel?.text = "\(product.title) - \(product.price)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectProduct(at: indexPath.row)
    }
}

private extension ProductsViewController {

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cart",
            style: .plain,
            target: self,
            action: #selector(cartButtonTapped)
        )
    }

    @objc func cartButtonTapped() {
        let cartVC = dependencyContainer.makeCartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
}
