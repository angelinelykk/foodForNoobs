//
//  ViewController.swift
//  testApi
//
//  Created by Max Wilcoxson on 11/14/21.
//

import UIKit


//Example ViewController where I initialize a new user, perform a search, and get the first image of a recipe in the search
class ViewController: UIViewController {
    
    let imageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        //Register new user on the RecipeAPi instance
        RecipeAPI.shared.register(username: "alexander12435678", password: "yay", completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                //Login
                RecipeAPI.shared.login(username: "alexander1243567", password: "yay", completion: { result in
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
        var recipes = [Recipe]()
        //Perform a search for recipes with the word thai in either title or ingredients
        RecipeAPI.shared.makeMealPlan(numMeals: 5, cuisines: ["thai","italian"], nutritionRanges: NutritionRange(minimum: OptionalNutrition(fat: 2, nrg: 3, pro: 4, sat: 5, sod: 6, sug: 7), maximum: OptionalNutrition(fat: 10, nrg: 11, pro: 12, sat: 13, sod: 14, sug: 15)), ingredients: ["pasta"], completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                recipes = data
                var image : UIImage?
                    //Get the image for the first image in the first recipe retrieved in the previous search
                    RecipeAPI.shared.getImage(id: recipes[0].image_ids[0], completion: { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let im):
                            DispatchQueue.main.sync {
                                self.imageView.image = im
                            }
                        }
                    })
            }
        })
    }
    
    
}

