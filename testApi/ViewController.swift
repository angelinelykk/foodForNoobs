//
//  ViewController.swift
//  testApi
//
//  Created by Max Wilcoxson on 11/14/21.
//

import UIKit


//Example ViewController where I initialize a new user, perform a search, and get the first image of a recipe in the search
class ViewController: UIViewController {
    
    let imageViews : [UIImageView] = {
        return (0..<5).map { index in
                let view = UIImageView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
        }
    }()
    let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        for imageView in imageViews {
            contentView.addSubview(imageView)
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            imageViews[0].topAnchor.constraint(equalTo: contentView.topAnchor),
            imageViews[0].centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageViews[0].widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        for i in 1..<imageViews.count {
            NSLayoutConstraint.activate([
                imageViews[i].topAnchor.constraint(equalTo: imageViews[i-1].bottomAnchor),
                imageViews[i].centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageViews[i].widthAnchor.constraint(equalTo: contentView.widthAnchor)
            ])
        }
        NSLayoutConstraint.activate([
            imageViews[imageViews.count-1].bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        //Register new user on the RecipeAPi instance
        RecipeAPI.shared.register(username: "test53441456", password: "yay", email: "test53441456@e.com", completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                //Login
                RecipeAPI.shared.login(username: "test53441456", password: "yay", completion: { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success:
                        //Then execute api calls (probably a better way to run these asynchronous wait calls than nested completions)
                        self.finishLoading()
                    }
                })
            }
        })
        
    }
    
    func finishLoading() {
        //Perform a search for recipes with the word thai in either title or ingredients
        //RecipeAPI.shared.makeMealPlan(numMeals: 5, cuisines: ["italian"], nutritionRanges: NutritionRange(minimum: OptionalNutrition(fat: -1, nrg: -1, pro: 17, sat: -1, sod: 0.15, sug: -1), maximum: OptionalNutrition(fat: -1, nrg: -1, pro: -1, sat: -1, sod: 0.3, sug: 15)), ingredients: ["pasta","basil"], completion: { result in
        RecipeAPI.shared.makeMealPlan(numMeals: 5, cuisines: ["Recipe"], ingredients: ["Alexander Hamilton"], completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                var response = data
                //let failed_nutrition = response.missing_nutrition
                let failed_ingredients = response.missing_ingredients
                //print("missing nutrition: " + String(describing: failed_nutrition))
                print("missing ingredients: " + String(describing: failed_ingredients))
                let recipes = response.recipes
                print(recipes)
                var image : UIImage?
                    //Get the image for the first image in the first recipe retrieved in the previous search
                for i in 0..<self.imageViews.count {
                    RecipeAPI.shared.makeReview(recipe_id: recipes[i].id, rating: 1, review: recipes[i].title, completion: { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let string):
                            print(string)
                        }
                    })
                    RecipeAPI.shared.toggleRecipeLike(recipe_id: recipes[i].id, completion: { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let string):
                            print(string)
                        }
                    })
                    if i == 0 {
                        RecipeAPI.shared.getAllReviews(recipe_id: recipes[i].id, completion: { result in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let reviews):
                                print(reviews)
                            }
                        })
                    }
                    RecipeAPI.shared.getImage(id: recipes[i].image_ids[0], completion: { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let im):
                            DispatchQueue.main.sync {
                                self.imageViews[i].image = im
                            }
                        }
                    })
                    RecipeAPI.shared.getMostLikedRecipes(number: 4, completion: { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let recipes):
                            print(recipes)
                        }
                        
                    })
                }
            }
        })
    }
    
    
}

