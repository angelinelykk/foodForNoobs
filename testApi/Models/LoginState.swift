//
//  LoginState.swift
//  testApi
//
//  Created by Oleg Bezrukavnikov on 11/30/21.
//

import Foundation

class LoginState: ObservableObject {
    static let shared = LoginState()
    
    @Published var loggedIn = false
}
