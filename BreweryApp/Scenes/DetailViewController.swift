//
//  DetailViewController.swift
//  BreweryApp
//
//  Created by yc on 2022/02/28.
//

import UIKit
import SnapKit
import Kingfisher

protocol LikeButtonProtocol: AnyObject {
    func didTapLikeButton(brewery: Brewery)
    func didTapUnLikeButton(brewery: Brewery)
}

enum Like {
    case like
    case unlike
}
enum PushedFrom {
    case mainVC
    case likedVC
}

class DetailViewController: UIViewController {
    
    var brewery: Brewery?
    var pushedFrom: PushedFrom?
    var likeStatus: Like = .unlike
    weak var likeButtonDelegate: LikeButtonProtocol?
    private let userDefaultsManager = UserDefaultsManager()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.alwaysBounceVertical = true
        
        return scrollView
    }()
    private let contentView = UIView()
    
    private lazy var beerImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var taglineLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var abvLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        
        return label
    }()
    
    private lazy var foodPairingLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationItem()
        setupLikeBarButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}
extension DetailViewController {
    @objc func didTapRightBarButton() {
        guard var brewery = brewery else { return }
        switch likeStatus {
        case .unlike:
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            brewery.like = true
            _ = userDefaultsManager.saveBrewery(brewery: brewery)
            likeStatus = .like
            likeButtonDelegate?.didTapLikeButton(brewery: brewery)
        case .like:
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            brewery.like = false
            userDefaultsManager.removeBrewery(brewery: brewery)
            likeStatus = .unlike
            likeButtonDelegate?.didTapUnLikeButton(brewery: brewery)
        }
    }
}

private extension DetailViewController {
    func setupLikeBarButton() {
        switch likeStatus {
        case .like:
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        case .unlike:
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }
    }
    func setupView() {
        view.backgroundColor = .systemBackground
        guard let brewery = brewery else { return }
        setupLayout()
        beerImageView.kf.setImage(with: brewery.imageURL, placeholder: UIImage(named: "beer"))
        nameLabel.text = brewery.name
        taglineLabel.text = brewery.tagline
        descriptionLabel.text = brewery.description
        abvLabel.text = "• 도수: \(brewery.abv)%"
        foodPairingLabel.text = "• 어울리는 음식🍗: " + brewery.foodPairing.joined(separator: ", ")
        tipsLabel.text = "• Tip⭐️: " + brewery.tips
        likeStatus = userDefaultsManager.isInLikedBreweryList(brewery: brewery) ? .like : .unlike
    }
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [
            beerImageView,
            nameLabel,
            taglineLabel,
            descriptionLabel,
            abvLabel,
            foodPairingLabel,
            tipsLabel
        ].forEach { contentView.addSubview($0) }
        
        beerImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(200.0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(beerImageView.snp.bottom).offset(32.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        taglineLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(taglineLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        abvLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        foodPairingLabel.snp.makeConstraints {
            $0.top.equalTo(abvLabel.snp.bottom).offset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        tipsLabel.snp.makeConstraints {
            $0.top.equalTo(foodPairingLabel.snp.bottom).offset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview()
        }
    }
    func setupNavigationItem() {
        navigationItem.title = "상세정보🍻"
        navigationController?.navigationBar.prefersLargeTitles = false
        switch pushedFrom! {
        case .mainVC:
            navigationController?.navigationBar.topItem?.backButtonTitle = "🍺"
        case .likedVC:
            navigationController?.navigationBar.topItem?.backButtonTitle = "👍"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
    }
}
