//
//  IndividualRecipe.swift
//  testApi
//
//  Created by Angeline Lee on 1/12/21.
//

import Foundation
import UIKit

class IndividualRecipe: UIViewController {
    
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
            self.titleLabel.text = recipe!.title
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var image: UIImage?
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        
        view.addSubview(titleLabel)
        imageView.image = image
        self.imageView.frame = CGRect(x: view.center.x - view.bounds.height/8, y:view.center.y - view.bounds.height/3, width: view.bounds.height/4, height: view.bounds.height/4)
        view.addSubview(imageView)
    
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8),
        ])
        
        
        
        
    }
    
    init(givenRecipe: RecipeNoNutrition, givenImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = givenRecipe
        self.image = givenImage
        self.titleLabel.text = givenRecipe.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
