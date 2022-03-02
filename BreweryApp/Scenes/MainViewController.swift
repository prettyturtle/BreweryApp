//
//  MainViewController.swift
//  BreweryApp
//
//  Created by yc on 2022/02/27.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var currentPage = 1
    
    private let fetchData = FetchData()
    private var breweryList: [Brewery] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.rowHeight = MainTableViewCell.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationItem()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
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
        detailViewController.pushedFrom = .mainVC
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard currentPage != 1 else { return }
        if (indexPath.row + 1) / 25 + 1 == currentPage {
            fetchData.fetch(page: currentPage) { [weak self] breweryList, page in
                guard let self = self else { return }
                self.breweryList.append(contentsOf: breweryList)
                self.currentPage = page
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breweryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.setupView(brewery: breweryList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

extension MainViewController {
    @objc func didTapRightBarButton() {
        let likedViewController = LikedViewController()
        navigationController?.pushViewController(likedViewController, animated: true)
    }
}

private extension MainViewController {
    func fetch() {
        fetchData.fetch(page: currentPage) { [weak self] breweryList, page in
            guard let self = self else { return }
            self.breweryList = breweryList
            self.currentPage = page
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bookmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
    }
}
