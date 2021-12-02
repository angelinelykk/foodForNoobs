//
//  IndividualRecipe.swift
//  testApi
//
//  Created by Angeline Lee on 1/12/21.
//

import Foundation
import UIKit

class IndividualRecipe: UIViewController {
    
    private let reviewTextField: AuthTextField = {
        let tf = AuthTextField(title: "Leave a review")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let returnButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemMint
        btn.setTitle("Back", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemMint
        btn.setTitleColor(UIColor.white, for: .normal)
        
        return btn
    }()
    
    
    
    private let likeButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemMint
        btn.setTitle("Like", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemMint
        btn.setTitleColor(UIColor.white, for: .normal)
        
        return btn
    }()
    
    private let reviewButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemMint
        btn.setTitle("Reviews", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemMint
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
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
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
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
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.bold)
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
        
        view.addSubview(titleLabel)
        imageView.image = image
                self.imageView.frame = CGRect(x: view.center.x - view.bounds.height/10, y:view.center.y - view.bounds.height/4 - 10, width: view.bounds.height/5, height: view.bounds.height/5)
        view.addSubview(imageView)
        view.addSubview(returnButton)
        view.addSubview(likeButton)
        view.addSubview(reviewButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            likeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            
            reviewButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            reviewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            
            
            returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            returnButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5)
            
            
        ])
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        scrollViewContainer.addArrangedSubview(ingredientsLabel)
        scrollViewContainer.addArrangedSubview(ingredientsList)
        scrollViewContainer.addArrangedSubview(instructionsLabel)
        scrollViewContainer.addArrangedSubview(instructionsList)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/2).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
        
        likeButton.addTarget(self, action: #selector(didTapLike(_:)), for: .touchUpInside)
        
        reviewButton.addTarget(self, action: #selector(didTapReview(_:)), for: .touchUpInside)
     
        
    }
    
    init(givenRecipe: RecipeNoNutrition, givenImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = givenRecipe
        self.image = givenImage
        self.titleLabel.text = givenRecipe.title
        for dict in givenRecipe.ingredients {
            for value in dict.values {
                self.ingredientsList.text! += (value + "\n" + "\n")
            }
        }
        for dict in givenRecipe.instructions {
            for value in dict.values {
                self.instructionsList.text! += (value + "\n" + "\n")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapReturn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapLike(_ sender: UIButton) {
        RecipeAPI.shared.toggleRecipeLike(recipe_id: recipe!.id, completion: nil)
        print("pressed like")
    }
    
    @objc func didTapReview(_ sender: UIButton) {
        scrollView.removeFromSuperview()
        view.addSubview(reviewTextField)
        NSLayoutConstraint.activate([
            reviewTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviewTextField.topAnchor.constraint(equalTo: reviewButton.bottomAnchor, constant: 5)
        ])
        
        
        
    }
}
