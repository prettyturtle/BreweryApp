//
//  LikedViewController.swift
//  BreweryApp
//
//  Created by yc on 2022/03/01.
//

import UIKit
import SnapKit

class LikedViewController: UIViewController {
    // TODO: 즐겨찾기 탭에서 상세정보 탭으로 간 상황에서 즐겨찾기를 해제했을 때, 다시 즐겨찾기 탭으로 넘어오면 적용이 안되어있는 점. 수정해야함
    var likedBreweryList = [Brewery]()
    private let userDefaultsManager = UserDefaultsManager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.rowHeight = MainTableViewCell.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
        return tableView
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "beer")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "아무것도 없어용"
        label.font = .systemFont(ofSize: 32.0, weight: .semibold)
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationItem()
        if likedBreweryList.isEmpty {
            [imageView, emptyLabel].forEach { view.addSubview($0) }
            imageView.snp.makeConstraints {
                $0.size.equalTo(150.0)
                $0.center.equalToSuperview()
            }
            emptyLabel.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(8.0)
                $0.centerX.equalTo(imageView.snp.centerX)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        likedBreweryList = userDefaultsManager.getBreweryList()
    }
}
extension LikedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.brewery = likedBreweryList[indexPath.row]
        detailViewController.pushedFrom = .likedVC
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // TODO: 셀의 순서 변경 또는 밀어서 삭제 기능 추가 예정
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userDefaultsManager.removeBrewery(brewery: likedBreweryList[indexPath.row])
            likedBreweryList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
extension LikedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedBreweryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.setupView(brewery: likedBreweryList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
}

private extension LikedViewController {
    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func setupNavigationItem() {
        navigationItem.title = "좋아요"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.backButtonTitle = "🍺"
    }
}
