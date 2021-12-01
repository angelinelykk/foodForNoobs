//
//  RecipeCategories.swift
//  testApi
//
//  Created by Angeline Lee on 30/11/21.
//

import Foundation
import UIKit

enum RecipeCategories: String, CaseIterable {
    case topSection = "Top Section"
    case suggestedByCreators = "Suggested by the Creators"
    case bestUnder15Mins = "Best under 15 minutes"
    
    init?(index: Int) {
        guard index < RecipeCategories.allCases.count else { return nil }
        self = RecipeCategories.allCases[index]
    }
    
    func numberOfRows() -> Int{
        switch self {
        case .topSection:
            return 2
        case .suggestedByCreators, .bestUnder15Mins:
            return 1
        }
    }
    
    func getScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .topSection:
            return .groupPaging
        
        case .suggestedByCreators, .bestUnder15Mins:
            return .paging
        }
    }
}
