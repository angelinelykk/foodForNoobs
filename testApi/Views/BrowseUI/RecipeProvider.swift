//
//  RecipeProvider.swift
//  testApi
//
//  Created by Angeline Lee on 1/12/21.
//

import Foundation
import UIKit

class RecipeProvider {
    static var topSection: [RecipeNoNutrition] = []
    static var bestUnder15: [RecipeNoNutrition] = []
    static var recommendedByCreators: [RecipeNoNutrition] = []
    static let recipes: [RecipeCategories: [RecipeNoNutrition]]? = {
        //fill top section
        
        var r: [RecipeCategories: [RecipeNoNutrition]] = [:]
        
        RecipeAPI.shared.getMostLikedRecipes(number: 20, completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let recipes):
                topSection = recipes
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
            case .success(let recipes):
                bestUnder15 = recipes
            }
        })
        // fill recommended
        let recommended: [String] = ["chicken"]
        RecipeAPI.shared.search(searchTerms: recommended, criteria: ingredients, has_nutrition: false, completion: {
            result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let recipes):
                recommendedByCreators = recipes
            }
        })
        
        r[RecipeCategories.topSection] = topSection
        r[RecipeCategories.bestUnder15Mins] = bestUnder15
        r[RecipeCategories.suggestedByCreators] = recommendedByCreators
        return r
        
    }()
}
