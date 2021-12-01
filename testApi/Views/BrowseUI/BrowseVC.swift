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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Recipe>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureViews()
        configureDataSource()
    }
}

extension BrowseVC {
    func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let category = Section(index: sectionIndex) else { fatalError("Unknown section kind") }
            
            let itemsPerRow = 4
            let rowHeight: CGFloat = 70.0
            let rowSpacing: CGFloat = 35
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
            frame: view.bounds.inset(by: UIEdgeInsets(top: 88, left: 0, bottom: 0, right: 0)),
            collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<BrowseCollectionCell, Recipe> {
            (cell, indexPath, identifier) in
            cell.recipe = identifier
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: BrowseVC.headerElementKind) { headerView, elementKind, indexPath in
            guard let section = Section(index: indexPath.section) else {
                fatalError("Unknown section")
            }
            headerView.label.text = section.rawValue
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Recipe>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Recipe) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
//        dataSource.apply(genereateSnapshot(), animatingDifferences: false)
    }
    
//    func genereateSnapshot() -> NSDiffableDataSourceSnapshot<Section, Recipe> {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>()
//        RecipeCategories.allCases.forEach { category in
//            guard let items = SymbolProvider.symbols?[category] else {
//                fatalError("Unknown category")
//            }
//            snapshot.appendSections([category])
//            snapshot.appendItems(items)
//        }
//
//        return snapshot
//    }
}



