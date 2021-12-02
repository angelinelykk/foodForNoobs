//
//  BrowseSwiftUI.swift
//  testApi
//
//  Created by Oleg Bezrukavnikov on 12/1/21.
//

import Foundation
import SwiftUI

struct BrowseSwiftUI: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BrowseVC {
        return BrowseVC.shared
    }
    
    func updateUIViewController(_ uiViewController: BrowseVC, context: Context) {
        
    }
}
