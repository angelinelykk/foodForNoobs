import UIKit

import Foundation

class MealPlanResponse {
    var recipes : [Recipe]
    var missing_nutrition : [String: Float]
    var missing_ingredients : [String]
    init(recipes : [Recipe], missing_nutrition: [String: Float], missing_ingredients: [String]) {
        self.recipes = recipes
        self.missing_nutrition = missing_nutrition
        self.missing_ingredients = missing_ingredients
    }
}
class MealPlanResponseNoNutrition {
    var recipes : [RecipeNoNutrition]
    var missing_ingredients : [String]
    init(recipes : [RecipeNoNutrition], missing_ingredients: [String]) {
        self.recipes = recipes
        self.missing_ingredients = missing_ingredients
    }
}
struct Review: Codable {
    var id : String
    var username : String
    var rating : Int
    var text : String
}

public struct Recipe: Codable, Hashable {
    //Equatable conformance
    public static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
    
    //This is the recipe class which holds all relevant information about a recipe.
    
    //Involved in decoding a recipe
    enum CodingKeys: String, CodingKey {
        case nutritionSummary = "fsa_lights_per100g"
        case ingredient_units = "unit"
        case id, ingredients, instructions, nutr_per_ingredient, image_ids,quantity, nutr_values_per100g, title,url,weight_per_ingr, likes, rating, num_of_reviews
    }
    
    //Assigns colors to four catagories of nutrition: Fat, Salt, Saturates, Sugars
    var nutritionSummary : Dictionary<String, String>
    
    //var hashID = UUID().uuidString
    
    var id : String
    //A list of ingredients, each item is an ingredient
    var ingredients : [String]
    //A list of instructions, each item is a sentence
    var instructions : [String]
    //A list of Nutrition objects (see below). Each nutrition object is coindexed with an ingredient in "ingredients," gives nutrition info for that ingredient
    var nutr_per_ingredient : [Nutrition]
    //A Nutrition object for the nutrition of the specfic obect
    var nutr_values_per100g : Nutrition
    var title : String
    //Units of each ingredient, coindexed with ingredients in "ingredients"
    var unit : [String]
    //Quantity of each ingredient
    var quantity : [Dictionary<String, String>]
    //A list of ids which correspond to images that can be retrieved from the server with the getImage(id: ) method
    var image_ids : [String]
    //A url to the original article of the recipe
    var url : URL
    //Weight of each ingredient, coindexed with ingredients in "ingredients"
    var weight_per_ingr : [Double]
    //Number of likes
    var likes : Int
    //Average star rating
    var rating : Float
    //Number of reviews
    var num_of_reviews : Int
    public init(from decoder: Decoder) throws {
        let container =  try decoder.container(keyedBy: CodingKeys.self)
        nutritionSummary = try container.decode(Dictionary<String, String>.self, forKey: .nutritionSummary)
        id = try container.decode(String.self, forKey: .id)
        ingredients = getValues(dicts : try container.decode([Dictionary<String, String>].self, forKey: .ingredients))
        instructions = getValues(dicts : (try container.decode([Dictionary<String, String>].self, forKey: .instructions)))
        nutr_per_ingredient = try container.decode([Nutrition].self, forKey: .nutr_per_ingredient)
        print(nutr_per_ingredient)
        title = try container.decode(String.self, forKey: .title)
        unit = getValues(dicts : (try container.decode([Dictionary<String, String>].self, forKey: .ingredient_units)))
        url = try container.decode(URL.self, forKey: .url)
        image_ids = try container.decode([String].self, forKey: .image_ids)
        quantity = try container.decode([Dictionary<String, String>].self, forKey: .quantity)
        weight_per_ingr = try container.decode([Double].self, forKey: .weight_per_ingr)
        nutr_values_per100g = try container.decode(Nutrition.self, forKey: .nutr_values_per100g)
        likes = try container.decode(Int.self, forKey: .likes)
        rating = try container.decode(Float.self, forKey: .rating)
        num_of_reviews = try container.decode(Int.self, forKey: .num_of_reviews)
    }
    public func encode(to encoder: Encoder) throws {
        fatalError("not implemented yet")
    }
    
    //public func hash(into hasher: inout Hasher) {
    //    hasher.combine(hashID)
    //}
}
public struct RecipeNoNutrition : Codable, Hashable {
    var id : String
    //A list of ingredients, each item is an ingredient
    var ingredients : [Dictionary<String, String>]
    //A list of instructions, each item is a sentence
    var instructions : [Dictionary<String, String>]
    var title : String
    //Quantity of each ingredient
    var image_ids : [String]
    //Number of likes
    var likes : Int
    //Average star rating
    var rating : Float
    //Number of reviews
    var num_of_reviews : Int
    
    
    //Hashable conformance
    //var hashID = UUID().uuidString
        
    //public func hash(into hasher: inout Hasher) {
    //    hasher.combine(hashID)
    //}
        
    //Equatable conformance
    public static func == (lhs: RecipeNoNutrition, rhs: RecipeNoNutrition) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: String, ingredients: [String], instructions: [String], title : String, image_ids : [String]) {
        self.id = id
        var ingredientsDict = [Dictionary<String, String>]()
        for ingredient in ingredients {
            ingredientsDict.append(["text":ingredient])
        }
        self.ingredients = ingredientsDict
        var instructionsDict = [Dictionary<String, String>]()
        for instruction in instructions {
            instructionsDict.append(["text":instruction])
        }
        self.instructions = instructionsDict
        self.title = title
        self.image_ids = image_ids
        self.likes = 0
        self.rating = 0
        self.num_of_reviews = 0
    }
}
//Heler method for decode
func getValues(dicts: [Dictionary<String, String>]) -> [String] {
    var result = [String]()
    for dictionary in dicts {
        result.append(dictionary["text"]!)
    }
    return result
}

//Nutrition class. Fat correspnds to fat, nrg calories, pro is protein, sat is saturated fast, sod is sodium, and sug is sugar
struct Nutrition: Codable, Hashable {
    var fat : Double
    var nrg : Double
    var pro : Double
    var sat : Double
    var sod : Double
    var sug : Double
    init(dict: [String: Double]) {
        self.fat = dict["fat"] ?? -1
        self.nrg = dict["nrg"] ?? -1
        self.pro = dict["pro"] ?? -1
        self.sat = dict["sat"] ?? -1
        self.sod = dict["sod"] ?? -1
        self.sug = dict["sug"] ?? -1
    }
}

struct NutritionRange: Codable {
    var minimum : Nutrition
    var maximum : Nutrition
    init(minimum: Nutrition, maximum: Nutrition) {
        self.minimum = minimum
        self.maximum = maximum
    }
}
//Some errors for error reporting to user. Not fully implemented yet
enum SignUpError : Error {
    case emailAlreadyInUse
    case errorWritingToDatabase
    case weakPassword
    case invalidPassword
    case usageLimitExceeded
    case unspecified
}

//Class which manages all API requests. Initialize a RecipeAPI with a usernae and password
class RecipeAPI {
    //Token for api acccess. Automatically renewed by the validateToken method
    private var token: String!
    private var loginTime : Date!
    //Stores username and password for authentication. Refresh tokens --> user signs in two tokens. One is regular session token one is a refresh token. Session token expires in a week. Refresh in a month. Refresh can be used to create a new token... etc.
    var username : String!
    private var password : String!
    //Shared instance. This is how the API should be accessed
    static let shared = RecipeAPI()
    //Call register on the shared api object to register a new user. Optional completion gives a result with either an error or string which indicates sucesss
    func register(username: String, password: String, email: String, completion: ((Result<String,SignUpError>)->Void)?) {
        let user_data = ["username":username, "password": password,"email":email]
        self.username = username
        self.password = password
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/register")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: user_data, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let dictionary = try! JSONSerialization.jsonObject(with: data!) as! Dictionary<String,AnyObject>
            completion?(.success(dictionary["message"] as! String))
        })
        task.resume()
    }
    //Call login on the shared object to login a user and save a new token for authentication. Returns completion with string "success" if sucessful, invalid password if not sucessful.
    func login(username: String, password: String, completion: ((Result<String,SignUpError>)->Void)?) {
        let user_data_string = username + ":" + password
        self.username = username
        let data = user_data_string.data(using: String.Encoding.utf8)
        let loginData = data?.base64EncodedString()
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/login")!)
        request.httpMethod = "POST"
        request.addValue("Basic " + loginData!, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            self.loginTime = Date.now
            let dictionary = try! JSONSerialization.jsonObject(with: data!) as! Dictionary<String,AnyObject>
            if let token = dictionary["token"] as? String {
                self.token = token
                completion?(.success("success"))
            } else {
                completion?(.failure(.invalidPassword))
            }
            
        })
        task.resume()
    }
    //Validate token is called by all APIs which require auth to make sure the token is current (not expired)
    func validate_token() {
        if Int(Date.now.timeIntervalSince(self.loginTime)) > 1500 {
            self.login(username: self.username, password: self.password, completion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let token):
                    self.token = token
                    self.loginTime = Date.now
                }
            })
        }
    }
    //API to search for recipes. takes an array of criteria (Strings) to find in an array of possible fields in the recipe. Allowed are title, ingredients, instructions.
    func search(searchTerms: [String], criteria: [String], completion: ((Result<[Recipe],SignUpError>)->Void)?) {
        validate_token()
        let dish_name = searchTerms.joined(separator: "-")
        let criteria_names = criteria.joined(separator: "-")
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/dish_keywords=" + dish_name + "&criteria=" + criteria_names + "&has_nutrition=true")!)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let decoder = JSONDecoder()
            do {
                let http = urlresponse as! HTTPURLResponse
                if http.statusCode == 403 {
                    completion?(.failure(.usageLimitExceeded))
                    print("Usage Limit Exceeded")
                }
                let recipes = try decoder.decode([Recipe].self, from: data!)
                completion?(.success(recipes))
            } catch {
                print(error)
            }
            
        })
        task.resume()
    }
    //API to search for recipes with no nutritional info. takes an array of criteria (Strings) to find in an array of possible fields in the recipe. Allowed are title, ingredients, instructions.
    func search(searchTerms: [String], criteria: [String], has_nutrition: Bool, completion: ((Result<[RecipeNoNutrition],SignUpError>)->Void)?) {
        validate_token()
        let dish_name = searchTerms.joined(separator: "-")
        let criteria_names = criteria.joined(separator: "-")
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/dish_keywords=" + dish_name + "&criteria=" + criteria_names + "&has_nutrition=" + String(has_nutrition))!)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let decoder = JSONDecoder()
            do {
                let http = urlresponse as! HTTPURLResponse
                if http.statusCode == 403 {
                    completion?(.failure(.usageLimitExceeded))
                    print("Usage Limit Exceeded")
                }
                let recipes = try decoder.decode([RecipeNoNutrition].self, from: data!)
                completion?(.success(recipes))
            } catch {
                print(error)
            }
            
        })
        task.resume()
    }
    //API to get an image from an imageID, found in a recipe object
    func getImage(id: String, completion: ((Result<UIImage,SignUpError>)->Void)?) {
        validate_token()
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/image/" + id)!)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let decoder = JSONDecoder()
            do {
                let http = urlresponse as! HTTPURLResponse
                if http.statusCode == 403 {
                    completion?(.failure(.usageLimitExceeded))
                    print("Usage Limit Exceeded")
                }
                let data = Data(base64Encoded: data!)
                if let image = UIImage(data: data!) {
                    completion?(.success(image))
                } else {
                    print("couldn't decode image")
                }
            } catch {
                print(error)
            }
            
        })
        task.resume()
    }
    //Function makes a meal plan. Takes in a number of meals, string array of cuisine names, nutrition range constructed with two OptionalNutition objects minimum and maximum, and a string array of ingredients. Backend to return relevant recipes implemented to try to match constraints, will return recipes and constraints it does not match. Cuisines are taken as guidance but not guaranteed. They filter set of searched recipes, but response will not necessarily contain all cuisines. The completion has either an error or MealPlanResponse, which has recipes as well as criteria that were missed.
    func makeMealPlan(numMeals: Int, cuisines: [String], nutritionRanges: NutritionRange, ingredients: [String], completion: ((Result<MealPlanResponse,SignUpError>)->Void)?) {
        validate_token()
        //URL with params?
        var nutritionString = ""
        nutritionString += "fat=" + String(nutritionRanges.minimum.fat) + "_" + String(nutritionRanges.maximum.fat) + "&"
        nutritionString += "nrg=" + String(nutritionRanges.minimum.nrg) + "_" +  String(nutritionRanges.maximum.nrg) + "&"
        nutritionString += "sat=" + String(nutritionRanges.minimum.sat) + "_" + String(nutritionRanges.maximum.sat) + "&"
        nutritionString += "sod=" + String(nutritionRanges.minimum.sod) + "_" + String(nutritionRanges.maximum.sod) + "&"
        nutritionString += "sug=" + String(nutritionRanges.minimum.sug) + "_" + String(nutritionRanges.maximum.sug) + "&"
        nutritionString += "pro=" + String(nutritionRanges.minimum.pro) + "_" + String(nutritionRanges.maximum.pro)
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/make_meal_plan/meals=\(numMeals)&cuisine=\(cuisines.joined(separator: "-"))&nutrition=\(nutritionString)&ingredients=\(ingredients.joined(separator: "-"))")!)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let decoder = JSONDecoder()
            do {
                let http = urlresponse as! HTTPURLResponse
                if http.statusCode == 403 {
                    completion?(.failure(.usageLimitExceeded))
                    print("Usage Limit Exceeded")
                }
                let dictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                let missedCriteria = dictionary["not_met"] as! [String: Any]
                let missed_nutrition = missedCriteria["nutrition"] as! [String: Float]
                let missed_ingredients = missedCriteria["ingredients"] as! [String]
                let result = dictionary["result"] as! [NSDictionary]
                let result_data = try! JSONSerialization.data(withJSONObject: result, options: [])
                let recipes = try decoder.decode([Recipe].self, from: result_data)
                completion?(.success(MealPlanResponse(recipes: recipes, missing_nutrition: missed_nutrition, missing_ingredients: missed_ingredients)))
            } catch {
                print(error)
            }
            
        })
        task.resume()
    }
    
    //Function makes a meal plan, does not consider or include nutritional information when making a meal plan.
    func makeMealPlan(numMeals: Int, cuisines: [String], ingredients: [String], completion: ((Result<MealPlanResponseNoNutrition,SignUpError>)->Void)?) {
        validate_token()
        var request = URLRequest(url: URL(string: ("https://mdbapi.dev/api/make_meal_plan/meals=\(numMeals)&cuisine=\(cuisines.joined(separator: "-"))&nutrition=NONE&ingredients=\(ingredients.joined(separator: "-"))").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let decoder = JSONDecoder()
            do {
                let http = urlresponse as! HTTPURLResponse
                if http.statusCode == 403 {
                    completion?(.failure(.usageLimitExceeded))
                    print("Usage Limit Exceeded")
                }
                let dictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                let missedCriteria = dictionary["not_met"] as! [String: Any]
                let missed_ingredients = missedCriteria["ingredients"] as! [String]
                let result = dictionary["result"] as! [NSDictionary]
                let result_data = try! JSONSerialization.data(withJSONObject: result, options: [])
                let recipes = try decoder.decode([RecipeNoNutrition].self, from: result_data)
                completion?(.success(MealPlanResponseNoNutrition(recipes: recipes, missing_ingredients: missed_ingredients)))
            } catch {
                print(error)
            }
            
        })
        task.resume()
    }
    
    //Method to post a rating/review of a recipe. Must include a rating, text of review is optional.
    //If the user has already posted a review for that recipe, it will overwrite the preview review.
    func makeReview(recipe_id: String, rating: Int, review: String?,completion: ((Result<String,SignUpError>)->Void)?) {
        let review = review ?? ""
        validate_token()
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/rate_recipe")!)
        let review_data = ["recipe_id":recipe_id, "rating": String(rating),"text":review]
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        request.httpBody = try? JSONSerialization.data(withJSONObject: review_data, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let dictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            completion?(.success(dictionary["message"] as! String))
            
        })
        task.resume()
    }
    
    //Likes or unlikes a recipe, depending on whether user has previously liked the recipe
    func toggleRecipeLike(recipe_id: String, completion: ((Result<String,SignUpError>)->Void)?) {
        validate_token()
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/toggle_like/\(recipe_id)")!)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let dictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            completion?(.success(dictionary["message"] as! String))
            
        })
        task.resume()
    }
    
    //Retrieves all reviews for a given recipe. See Recipe struct for contents/syntax of a review. A recipe object returned from other views will include number of reviews and avg stars, but will not include the complete set of ratings, authors, and texts.
    func getAllReviews(recipe_id: String, completion: ((Result<[Review],SignUpError>)->Void)?) {
        validate_token()
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/get_ratings/\(recipe_id)")!)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let decoder = JSONDecoder()
            do {
                let reviews = try decoder.decode([Review].self, from: data!)
                completion?(.success(reviews))
            } catch {
                print(error)
            }
            
        })
        task.resume()
    }
    //Method to upload recipe called by addrecipe view
    func uploadRecipe(title: String, amounts: [String], ingredients: [String], instructions: [String], image: UIImage) {
        let id = UUID().uuidString
        var ingredients_full = [String]()
        for i in 0..<amounts.count {
            ingredients_full.append(amounts[i] + " " + ingredients[i])
        }
        let recipe = RecipeNoNutrition(id: id, ingredients: ingredients_full, instructions: instructions, title: title, image_ids: [id])
        validate_token()
        uploadRecipe(recipe: recipe)
        uploadImage(image: image, id: id)
    }
    //Helper method to upload image
    private func uploadImage(image: UIImage, id: String) {
        let imageString = image.jpegData(compressionQuality: 1)!.base64EncodedString()
        let dictionaryImage = ["image" : imageString, "id" : id]
        let jsonData = try! JSONEncoder().encode(dictionaryImage)
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/upload_image")!)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
    
    //Function to upload recipe, called by the uploadRecipe method (this is a helper method)
    private func uploadRecipe(recipe: RecipeNoNutrition) {
        let jsonData = try! JSONEncoder().encode(recipe)
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/upload_recipe")!)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
    
    //Returns completion for number most liked recipes on the database. Useful for feed of popular recipes.
    func getMostLikedRecipes(number: Int, completion: ((Result<[RecipeNoNutrition],SignUpError>)->Void)?) {
        validate_token()
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/get_most_liked/\(number)")!)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "x-access-tokens")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, urlresponse, error in
            if let error = error {
                print(error)
                completion?(.failure(.unspecified))
            }
            let decoder = JSONDecoder()
            do {
                let reviews = try decoder.decode([RecipeNoNutrition].self, from: data!)
                completion?(.success(reviews))
            } catch {
                print(error)
            }
            
        })
        task.resume()
    }
}
