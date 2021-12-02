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
            
            if let likes = recipe?.likes {
                likesView.text = String(likes)
            }
            if let rating = recipe?.rating {
                if let votes = recipe?.num_of_reviews {
                    if rating > 0 {
                        ratingView.text = String(rating) + " (" + String(votes) + ")"
                    } else {
                        ratingView.text = "No reviews"
                    }
                }
            }
        }
    }
    
    let imageView: UIImageView = {
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
    
    private let likesImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let likesView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let ratingView: UILabel = {
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
        contentView.addSubview(likesView)
        contentView.addSubview(ratingView)
        contentView.addSubview(likesImageView)
        contentView.addSubview(ratingImageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleView.topAnchor, constant: -7),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: likesView.topAnchor, constant: -7),
            likesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            likesImageView.topAnchor.constraint(equalTo: likesView.topAnchor),
            likesImageView.bottomAnchor.constraint(equalTo: likesView.bottomAnchor),
            ratingImageView.topAnchor.constraint(equalTo: likesView.topAnchor),
            ratingImageView.bottomAnchor.constraint(equalTo: likesView.bottomAnchor),
            likesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            likesView.leadingAnchor.constraint(equalTo: likesImageView.trailingAnchor, constant: 3),
            ratingImageView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor, constant: 5),
            ratingView.leadingAnchor.constraint(equalTo: ratingImageView.trailingAnchor, constant: 3),
            ratingView.topAnchor.constraint(equalTo: likesView.topAnchor),
            ratingView.bottomAnchor.constraint(equalTo: likesView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
