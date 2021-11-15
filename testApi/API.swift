import UIKit

import Foundation

public struct Recipe: Codable {
    //This is the recipe class which holds all relevant information about a recipe.
    
    //Involved in decoding a recipe
    enum CodingKeys: String, CodingKey {
        case nutritionSummary = "fsa_lights_per100g"
        case ingredient_units = "unit"
        case id, ingredients, instructions, nutr_per_ingredient, image_ids, nutr_values_per100g, title,url,weight_per_ingr
    }
    
    //Assigns colors to four catagories of nutrition: Fat, Salt, Saturates, Sugars
    var nutritionSummary : Dictionary<String, String>
    
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
    //A list of ids which correspond to images that can be retrieved from the server with the getImage(id: ) method
    var image_ids : [String]
    //A url to the original article of the recipe
    var url : URL
    //Weight of each ingredient, coindexed with ingredients in "ingredients"
    var weight_per_ingr : [Double]
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
        weight_per_ingr = try container.decode([Double].self, forKey: .weight_per_ingr)
        nutr_values_per100g = try container.decode(Nutrition.self, forKey: .nutr_values_per100g)
    }
    public func encode(to encoder: Encoder) throws {
        fatalError("not implemented yet")
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
struct Nutrition: Codable {
    var fat : Double
    var nrg : Double
    var pro : Double
    var sat : Double
    var sod : Double
    var sug : Double
}

//Some errors for error reporting to user. Not fully implemented yet
enum SignUpError : Error {
    case emailAlreadyInUse
    case errorWritingToDatabase
    case weakPassword
    case usageLimitExceeded
    case unspecified
}

//Class which manages all API requests. Initialize a RecipeAPI with a usernae and password
class RecipeAPI {
    //Token for api acccess. Automatically renewed by the validateToken method
    private var token: String!
    private var loginTime : Date!
    //Stores username and password for authentication
    private var username : String!
    private var password : String!
    //Shared instance. This is how the API should be accessed
    static let shared = RecipeAPI()
    //Call register on the shared api object to register a new user. Optional completion gives a result with either an error or string which indicates sucesss
    func register(username: String, password: String, completion: ((Result<String,SignUpError>)->Void)?) {
        let user_data = ["username":username, "password": password]
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
    //Call login on the shared object to login a user and save a new token for authentication.
    func login(username: String, password: String, completion: ((Result<String,SignUpError>)->Void)?) {
        let user_data_string = username + ":" + password
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
            self.token = dictionary["token"] as! String
            completion?(.success(dictionary["token"] as! String))
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
        var request = URLRequest(url: URL(string: "https://mdbapi.dev/api/dish_keywords=" + dish_name + "&criteria=" + criteria_names)!)
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
}
