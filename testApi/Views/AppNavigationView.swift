//
//  AppNavigationView.swift
//  testApi
//
//  Created by Oleg Bezrukavnikov on 11/30/21.
//

import Foundation
import SwiftUI

struct AppNavigationView: View {
    var body: some View {
        TabView {
            BrowseSwiftUI()
                .tabItem {
                    Image(systemName: "star")
                    Text("Browse")
                }
            SearchSwiftUI()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            PlanVCSwiftUI()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Search")
                }
            AddRecipe()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add Recipe")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }

        }
    }
}
