//
//  TitleSupplementaryView.swift
//  testApi
//
//  Created by Angeline Lee on 30/11/21.
//

import Foundation
import UIKit

class TitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not implemented")
    }
}

extension TitleSupplementaryView {
    func configure() {
        addSubview(label)
        label.frame = bounds.inset(by: UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 5))
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title2)
    }
}
