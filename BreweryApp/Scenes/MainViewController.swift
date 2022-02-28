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
    private var breweryList: [Brewery] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.rowHeight = 150.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationItem()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetch()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.brewery = breweryList[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breweryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.setupView(brewery: breweryList[indexPath.row])
        return cell
    }
}

private extension MainViewController {
    func fetch() {
        fetchData.fetch { [weak self] breweryList in
            guard let self = self else { return }
            self.breweryList = breweryList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
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
