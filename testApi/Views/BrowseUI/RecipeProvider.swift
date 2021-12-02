//
//  RecipeProvider.swift
//  testApi
//
//  Created by Angeline Lee on 1/12/21.
//

import Foundation
import UIKit

class RecipeProvider {
    static var recipes: [RecipeCategories: [RecipeNoNutrition]] = [:]
    
    static func getRecipesWithCategories() {
        
        RecipeAPI.shared.getMostLikedRecipes(number: 20, completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let r):
                recipes[RecipeCategories.topSection] = r as! [RecipeNoNutrition]
            }
        })
        
        //fill best under 15
        let beef: [String] = ["beef"]
        let ingredients: [String] = ["ingredients"]
        RecipeAPI.shared.search(searchTerms: beef, criteria: ingredients, has_nutrition: false, completion: {
            result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let r):
                recipes[RecipeCategories.bestUnder15Mins] = r as! [RecipeNoNutrition]
            }
        })
        // fill recommended
        let recommended: [String] = ["chicken"]
        RecipeAPI.shared.search(searchTerms: recommended, criteria: ingredients, has_nutrition: false, completion: {
            result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let r):
                recipes[RecipeCategories.suggestedByCreators] = r as! [RecipeNoNutrition]
                
            }
        })
        
    }

}
