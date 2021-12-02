//
//  BrowseVC.swift
//  testApi
//
//  Created by Angeline Lee on 30/11/21.
//

import Foundation
import UIKit

class BrowseVC: UIViewController {
    
    typealias Section = RecipeCategories
    
    static let headerElementKind = "symbol-header-kind"
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, RecipeNoNutrition>!
    
    var recipes: [RecipeCategories: [RecipeNoNutrition]] = [:]
    
    var navigationBar: UINavigationBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        
        navigationBar!.tintColor = .systemMint
        view.addSubview(navigationBar!)
        
        
        let navItem = UINavigationItem(title: "Try Something New")

        navigationBar!.setItems([navItem], animated: false)
        
        NSLayoutConstraint.activate([
            navigationBar!.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        RecipeAPI.shared.getMostLikedRecipes(number: 20, completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let r):
                self.recipes[RecipeCategories.trending] = r
                //fill thanksgiving
                let thanksgiving: [String] = ["thanksgiving"]
                let ingredientsAndTitle: [String] = ["title"]
                RecipeAPI.shared.search(searchTerms: thanksgiving, criteria: ingredientsAndTitle, has_nutrition: false, completion: {
                    result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let r):
                        self.recipes[RecipeCategories.thanksgiving] = r
                        // fill recommended
                        let quickAndEasy: [String] = ["Quick"]
                        let title: [String] = ["title"]
                        RecipeAPI.shared.search(searchTerms: quickAndEasy, criteria: title, has_nutrition: false, completion: {
                            result in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let r):
                                self.recipes[RecipeCategories.quickAndEasy] = r
                                DispatchQueue.main.sync {
                                    self.configureViews()
                                    self.configureDataSource()
                                }
                            }
                        })
                    }
                })
            }
        })
        
        //self.configureViews()
        //self.configureDataSource()
        
    }
}

extension BrowseVC {
    func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let category = Section(index: sectionIndex) else { fatalError("Unknown section kind") }
            
            let itemsPerRow = 2
            let rowHeight: CGFloat = 0.75*(self.view.frame.width/2)
            let rowSpacing: CGFloat = 16
            let headerEstimatedHeight: CGFloat = 44
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(itemsPerRow)),
                                                   heightDimension: .absolute(rowHeight)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
            
            let row = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(rowHeight)), subitems: [item])
            
            let rowGroupEstimatedHeight = rowHeight * CGFloat(category.numberOfRows()) +
                rowSpacing * CGFloat(category.numberOfRows() - 1)
            let rowGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(rowGroupEstimatedHeight)),
                subitem: row, count: category.numberOfRows())
            
            rowGroup.interItemSpacing = .fixed(rowSpacing)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .estimated(headerEstimatedHeight + rowHeight * CGFloat(category.numberOfRows()))), subitems: [rowGroup])
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = category.getScrollingBehavior()
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0), heightDimension: .estimated(headerEstimatedHeight)),
                elementKind: BrowseVC.headerElementKind, alignment: .topLeading)
            
            section.boundarySupplementaryItems = [sectionHeader]
            return section
                    
        }, configuration: config)
        
        return layout
    }
}

extension BrowseVC {
    func configureViews() {
        let layout = createLayout()
        collectionView = UICollectionView(
            frame: view.bounds.inset(by: UIEdgeInsets(top: 40, left: 0, bottom: 100, right: 0)),
            collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<BrowseCollectionCell, RecipeNoNutrition> {
            (cell, indexPath, identifier) in
            cell.recipe = identifier
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: BrowseVC.headerElementKind) { headerView, elementKind, indexPath in
            guard let section = Section(index: indexPath.section) else {
                fatalError("Unknown section")
            }
            headerView.label.text = section.rawValue
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, RecipeNoNutrition>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: RecipeNoNutrition) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        dataSource.apply(genereateSnapshot(), animatingDifferences: false)
    }
    
    func genereateSnapshot() -> NSDiffableDataSourceSnapshot<Section, RecipeNoNutrition> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecipeNoNutrition>()
        RecipeCategories.allCases.forEach { category in
            guard let items = self.recipes[category] else {
                fatalError("Unknown category")
            }
            snapshot.appendSections([category])
            snapshot.appendItems(items)
        }
        
        return snapshot
    }
}

extension BrowseVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! BrowseCollectionCell
        let vc = IndividualRecipe(givenRecipe: tappedCell.recipe!, givenImage: tappedCell.imageView.image!)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}

