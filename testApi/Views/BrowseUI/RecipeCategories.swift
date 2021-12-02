//
//  RecipeCategories.swift
//  testApi
//
//  Created by Angeline Lee on 1/12/21.
//

import Foundation
import UIKit

enum RecipeCategories: String, CaseIterable {
    case trending = "Trending Recipes"
    case thanksgiving = "Thanksgiving Ideas"
    case quickAndEasy = "Quick and Easy Recipes"
    
    init?(index: Int) {
        guard index < RecipeCategories.allCases.count else { return nil }
        self = RecipeCategories.allCases[index]
    }
    
    func numberOfRows() -> Int{
        switch self {
        case .trending:
            return 2
        case .thanksgiving, .quickAndEasy:
            return 1
        }
    }
    
    func getScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .trending:
            return .groupPaging
        
        case .thanksgiving, .quickAndEasy:
            return .paging
        }
    }
}
