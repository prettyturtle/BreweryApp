//
//  MainViewController.swift
//  BreweryApp
//
//  Created by yc on 2022/02/27.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private let fetchData = FetchData()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupLayout()
    }
    
}
private extension MainViewController {
    func setupLayout() {
        [
            tableView
        ].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func setupNavigationItem() {
        navigationItem.title = "브루어리🍺"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
