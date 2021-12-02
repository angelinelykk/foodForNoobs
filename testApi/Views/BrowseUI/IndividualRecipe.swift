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
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Ingredients"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ingredientsList: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var image: UIImage?
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.frame.size = CGSize(width: 50, height: 50)
        return iv
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Instructions"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionsList: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()

            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()
    
    private let scrollViewContainer: UIStackView = {
            let view = UIStackView()

            view.axis = .vertical
            view.spacing = 10

            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        imageView.image = image
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(titleLabel)
        
        scrollViewContainer.addArrangedSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        scrollViewContainer.addArrangedSubview(ingredientsLabel)
        scrollViewContainer.addArrangedSubview(ingredientsList)
        scrollViewContainer.addArrangedSubview(instructionsLabel)
        scrollViewContainer.addArrangedSubview(instructionsList)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

                scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
                scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
                scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
                scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
                // this is important for scrolling
                scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        scrollView = UIScrollView(frame: view.bounds)
//
//        view.addSubview(scrollView)
//
        //view.addSubview(titleLabel)
//        imageView.image = image
//        self.imageView.frame = CGRect(x: view.center.x - view.bounds.height/10, y:view.center.y - view.bounds.height/4 - 10, width: view.bounds.height/5, height: view.bounds.height/5)
//
//        view.addSubview(imageView)
//
//        view.addSubview(ingredientsLabel)
//
//        //ingredientslist
//        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.contentSize = ingredientsList.bounds.size
//        scrollView.addSubview(ingredientsList)
//        view.addSubview(scrollView)
//
//
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8),
//
//
//
//            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
//
//        ])
//
//        view.addSubview(stack)
//        stack.addArrangedSubview(ingredientsLabel)
//        stack.addArrangedSubview(ingredientsList)
//        stack.addArrangedSubview(instructionsLabel)
//        stack.addArrangedSubview(instructionsList)
//
//
//        NSLayoutConstraint.activate([
//            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
//                                           constant: contentEdgeInset.left),
//            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
//                                            constant: -contentEdgeInset.right),
//            stack.topAnchor.constraint(equalTo: imageView.bottomAnchor,
//                                       constant: 60)
//        ])
        
        
    }
    
    init(givenRecipe: RecipeNoNutrition, givenImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = givenRecipe
        self.image = givenImage
        self.titleLabel.text = givenRecipe.title
        for dict in givenRecipe.ingredients {
            for value in dict.values {
                self.ingredientsList.text! += (value + "\n")
            }
        }
        for dict in givenRecipe.instructions {
            for value in dict.values {
                self.instructionsList.text! += (value + "\n")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
