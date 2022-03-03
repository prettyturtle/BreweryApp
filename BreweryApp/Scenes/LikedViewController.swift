//
//  LikedViewController.swift
//  BreweryApp
//
//  Created by yc on 2022/03/01.
//

import UIKit
import SnapKit

class LikedViewController: UIViewController {
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
        setupEmptyImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        likedBreweryList = userDefaultsManager.getBreweryList()
    }
}
extension LikedViewController: LikeButtonProtocol {
    func didTapLikeButton(brewery: Brewery) {
        _ = userDefaultsManager.saveBrewery(brewery: brewery)
        likedBreweryList = userDefaultsManager.getBreweryList()
        tableView.reloadData()
    }
    
    func didTapUnLikeButton(brewery: Brewery) {
        userDefaultsManager.removeBrewery(brewery: brewery)
        likedBreweryList = userDefaultsManager.getBreweryList()
        tableView.reloadData()
    }
}

extension LikedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.brewery = likedBreweryList[indexPath.row]
        detailViewController.pushedFrom = .likedVC
        detailViewController.likeButtonDelegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // TODO: 셀의 순서 변경 또는 밀어서 삭제 기능 추가 예정
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userDefaultsManager.removeBrewery(brewery: likedBreweryList[indexPath.row])
            likedBreweryList.remove(at: indexPath.row)
            tableView.reloadData()
            setupEmptyImage()
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//TODO: 셀 순서 변경 구현 예정
//    }
}
extension LikedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedBreweryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.setupView(brewery: likedBreweryList[indexPath.row])
        cell.selectionStyle = .none
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(willEditingMode(_:))))
        
        return cell
    }
    @objc func willEditingMode(_ gestureRecognizer: UILongPressGestureRecognizer) {
        gestureRecognizer.minimumPressDuration = 0.8
        if gestureRecognizer.state == .began {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            setupEditingMode()
        }
    }
}

private extension LikedViewController {
    func setupEditingMode() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
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
    func setupEmptyImage() {
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
}
