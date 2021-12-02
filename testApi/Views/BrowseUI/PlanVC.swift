//
//  PlanVC.swift
//  testApi
//
//  Created by Michelle Chang on 1/12/21.
//

import UIKit


class PlanVC: UIViewController {
    
    var recipes = [RecipeNoNutrition]()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create Meal Plan"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private let numMealsTextField: AuthTextField = {
        let tf = AuthTextField(title: "Num Meals:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let ingredientsTextField: AuthTextField = {
        let tf = AuthTextField(title: "Ingredients:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let cuisinesTextField: AuthTextField = {
        let tf = AuthTextField(title: "Cuisines:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    private let mealButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Create Meal Plan!", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    private let signupButtonHeight: CGFloat = 44.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdgeInset.right)
        ])
        
        
            
        
        view.addSubview(stack)
        stack.addArrangedSubview(numMealsTextField)
        stack.addArrangedSubview(ingredientsTextField)
        stack.addArrangedSubview(cuisinesTextField)

        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                       constant: 60),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -contentEdgeInset.right)
                ])
        
        view.addSubview(mealButton)
                NSLayoutConstraint.activate([
                    mealButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                    mealButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
                    mealButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
                    mealButton.heightAnchor.constraint(equalToConstant: signupButtonHeight)
                ])
        
        mealButton.layer.cornerRadius = signupButtonHeight / 2
        mealButton.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    
    @objc func didTapSignUp(_ sender: UIButton) {
        guard let numMeals = numMealsTextField.text, numMeals != "" else {
            print("Number of Meals missing")
        return
        }
        
        guard let ingredients = ingredientsTextField.text, ingredients != "" else {
            print("Ingredients missing")
            return
        }
        
        guard let cuisines = cuisinesTextField.text, cuisines != "" else {
            print("Cuisines missing")
            return
        }
        
        guard let meals = Int(numMeals) else {
            print("Error")
            return
        }
        
        
        mealButton.showLoading()
        RecipeAPI.shared.makeMealPlan(numMeals: meals, cuisines: cuisines.components(separatedBy: " "), ingredients: ingredients.components(separatedBy: " "), completion: {results in
            switch results {
            case .failure(let error):
                print(error)
            case .success(let r):
                self.recipes = r.recipes
            }
        })
    }
}
                                      
        
    
