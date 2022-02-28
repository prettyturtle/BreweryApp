//
//  MainTableViewCell.swift
//  BreweryApp
//
//  Created by yc on 2022/02/27.
//

import UIKit
import SnapKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"
    
    private lazy var beerImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var taglineLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        return label
    }()
    
    func setupView(brewery: Brewery) {
        setupLayout()
        
        beerImageView.kf.setImage(with: brewery.imageURL)
        nameLabel.text = brewery.name
        taglineLabel.text = brewery.tagline
    }
}

private extension MainTableViewCell {
    func setupLayout() {
        [
            beerImageView,
            nameLabel,
            taglineLabel
        ].forEach { addSubview($0) }
        
        beerImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(16.0)
            $0.width.equalTo(beerImageView.snp.height)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerImageView.snp.trailing).offset(16.0)
            $0.top.equalTo(beerImageView.snp.top)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        taglineLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8.0)
            $0.trailing.equalToSuperview().inset(16.0)
        }
    }
}
