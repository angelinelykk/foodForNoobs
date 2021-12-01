//
//  ContentView.swift
//  testApi
//
//  Created by Oleg Bezrukavnikov on 11/30/21.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var loginState = LoginState.shared;

    var body: some View {
        if !loginState.loggedIn {
            LoginView()
        } else {
            AppNavigationView()
        }
    }
}
