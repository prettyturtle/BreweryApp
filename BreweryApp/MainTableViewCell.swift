//
//  MainTableViewCell.swift
//  BreweryApp
//
//  Created by yc on 2022/02/27.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        
        return label
    }()
    
    //TODO: Custom Cell 만들기
    
    func setupView(brewery: Brewery) {
        setupLayout()
        nameLabel.text = brewery.name
    }
}

private extension MainTableViewCell {
    func setupLayout() {
        [
            nameLabel
        ].forEach { addSubview($0) }
        
        nameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
