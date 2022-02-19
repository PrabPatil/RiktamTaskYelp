//
//  CollectionViewCell.swift
//  RiktamTaskYelp
//
//  Created by Prabhu Patil on 18/02/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    // MARK: - Properties
    lazy var roundedBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        //view.backgroundColor = .systemFill
        view.backgroundColor = .black
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOffset = CGSize(width: 0, height: 3)

        return view
    }()
        
    lazy var restaurantName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white//.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var locationName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .white//.systemBlue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}

// MARK: - UI Setup
extension CollectionViewCell {
    private func setupUI() {
        self.contentView.addSubview(roundedBackgroundView)
        let textStackView = UIStackView(arrangedSubviews: [restaurantName, locationName])
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.distribution = .fillEqually
        textStackView.spacing = 5
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        roundedBackgroundView.addSubview(textStackView)
        
        NSLayoutConstraint.activate([
            roundedBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            roundedBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            roundedBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            roundedBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            restaurantName.centerXAnchor.constraint(equalTo: roundedBackgroundView.centerXAnchor),
            restaurantName.centerYAnchor.constraint(equalTo: roundedBackgroundView.centerYAnchor)
        ])
    }
}
