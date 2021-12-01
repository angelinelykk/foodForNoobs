//
//  BrowseCollectionCell.swift
//  testApi
//
//  Created by Angeline Lee on 30/11/21.
//

import Foundation
import UIKit

class BrowseCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: BrowseCollectionCell.self)
    
    var recipe: RecipeNoNutrition? {
        didSet {
            RecipeAPI.shared.getImage(id: recipe!.image_ids[0], completion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let im):
                    DispatchQueue.main.sync {
                        self.imageView.image = im
                    }
                }
            })
            titleView.text = recipe?.title
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 45),
            imageView.bottomAnchor.constraint(equalTo: titleView.topAnchor, constant: -7),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

