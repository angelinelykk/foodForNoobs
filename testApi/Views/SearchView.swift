//
//  SearchView.swift
//  testApi
//
//  Created by Max Wilcoxson on 12/1/21.
//

import UIKit
import SwiftUI

class SearchView : UIViewController {
    public var recipes = [RecipeNoNutrition]()
    /*var searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search by name and type"
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
     */
    let textField: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = UIColor(hex: "#f7f7f7")
        tf.textColor = .primaryText
        tf.font = .systemFont(ofSize: 15, weight: .medium)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BrowseCollectionCell.self, forCellWithReuseIdentifier: BrowseCollectionCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
         
         //navigationBar.tintColor = .systemMint
         view.addSubview(textField)
        //self.navigationItem.titleView = searchController.searchBar
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 88, left: 16, bottom: 50, right: 16))
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        textField.delegate = self
    }
}
extension SearchView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipe = self.recipes[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseCollectionCell.reuseIdentifier, for: indexPath) as! BrowseCollectionCell
        cell.recipe = recipe
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
}
extension SearchView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-32, height: 0.75*view.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = self.recipes[indexPath.item]
        print("tapped!")
    }
}
/*
extension SearchView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text?.lowercased() else {
            return
        }
        if searchString != "" {
            RecipeAPI.shared.search(searchTerms: searchString.components(separatedBy: " "), criteria: ["title","ingredients","instructions"], has_nutrition: false, completion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let recipes):
                    self.recipes = recipes as! [RecipeNoNutrition]
                    DispatchQueue.main.sync {
                        self.collectionView.collectionViewLayout.invalidateLayout()
                        self.collectionView.reloadData()
                    }
                }
            })
        }
    }
    
}
*/

extension SearchView : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text != "" {
        RecipeAPI.shared.search(searchTerms: textView.text.components(separatedBy: " "), criteria: ["title","ingredients","instructions"], has_nutrition: false, completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let recipes):
                self.recipes = recipes as! [RecipeNoNutrition]
                DispatchQueue.main.sync {
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.reloadData()
                }
            }
        })
        }
    }
}




