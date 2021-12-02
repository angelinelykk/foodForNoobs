//
//  PlanVC.swift
//  testApi
//
//  Created by Michelle Chang on 1/12/21.
//
import SwiftUI

struct addMealPlan: View {
    @State var numMeals = 0
    @State var cuisines = [String](repeating: "", count: 1)
    @State var ingredients = [String](repeating: "", count: 1)
    
    
    func resetValues() {
        self.numMeals = 0
        self.cuisines = [String](repeating: "", count: 1)
        self.ingredients = [String](repeating: "", count: 1)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Form {
                    IngredientsView(ingredients: self.$ingredients, width: geometry.size.width)
                    mealPlanView(numMeals: self.numMeals, ingredients: self.ingredients, cuisines: self.cuisines)
                }
            }
    }
    }
    
    struct IngredientsView : View {
        @Binding var ingredients : [String]
        var width : CGFloat
        var body : some View {
            return Section(header: Text("Ingredients")) {
                List {
                ForEach((1...self.ingredients.count), id: \.self) { num in
                    HStack {
                        TextField("Ingredient " + String(num), text: self.$ingredients[num-1])
                            .frame(width: width*0.75)
                    }
                }
                .onDelete(perform: delete)
                }
                HStack {
                    Spacer()
                Button(action: {
                    self.ingredients.append("")
                }) {
                    //addIngredient()
                }
                Spacer()
            }
            }
        }
        func delete(at offsets: IndexSet) {
            if self.ingredients.count > 1 {
            self.ingredients.remove(atOffsets: offsets)
            }
        }
    }

    
    struct mealPlanView: View {
        var numMeals : Int
        var ingredients : [String]
        var cuisines : [String]
        
        @State var recipes = [RecipeNoNutrition]()

        
        @State var alert : Alert!
        @State var isPresented : Bool = false
        
        var body : some View {
            return HStack {
                Spacer()
                Button(action:
                {guard numMeals > 0 else {
                    self.alert = Alert(title: Text("Missing Number of Meals"), message: Text("Please add input"))
                    self.isPresented = true
                    return
                }
                            
                let ingredientsIndex = allNotNull(array: ingredients)
                guard ingredientsIndex == -1 else {
                self.alert = Alert(title: Text("Empty ingredient"), message: Text("Ingredient \(ingredientsIndex + 1) is empty"))
                self.isPresented = true
                return
                }
                            
                let cuisinesIndex = allNotNull(array: cuisines)
                guard cuisinesIndex == -1 else {
                self.alert = Alert(title: Text("Empty cuisines"), message: Text("Cuisines \(cuisinesIndex + 1) is empty"))
                self.isPresented = true
                return
            }
                            
            RecipeAPI.shared.makeMealPlan(numMeals: self.numMeals, cuisines: self.cuisines, ingredients: self.ingredients, completion: {
                results in switch results {
                    case .failure(let error):
                        print(error)
                    case .success(let r):
                        let chicken: [String] = ["chicken"]
                        let cuisine: [String] = ["Thai"]
                        RecipeAPI.shared.search(searchTerms: chicken, criteria: cuisine, has_nutrition: false, completion: {
                                result in
                                switch result {
                                    case .failure(let error):
                                        print(error)
                                    case .success(let r):
                                        self.recipes = r as! [RecipeNoNutrition]
                                    }
                                        
                                })
                            }
                })
                }, label: {
                        Spacer()
                }).alert(isPresented: self.$isPresented) {
                        self.alert
                    }
                }
            }
    }
}
