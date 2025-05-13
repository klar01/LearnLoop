//
//  UserManager.swift
//  LearnLoop
//
//  Created by Michael Rivera on 5/13/25.
//

import Foundation

class UserManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUserEmail: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let emailKey = "SavedEmail"
    private let passwordKey = "SavedPassword"
    private let isLoggedInKey = "IsLoggedIn"
    
    // sign up function saves credentials
    func signUp(email: String, password: String) -> Bool {
        // Basic validation
        guard !email.isEmpty, !password.isEmpty else { return false }
        guard isValidEmail(email) else { return false }
        guard password.count >= 6 else { return false }
        
        // check if user already exists
        if userExists(email: email) {
            return false
        }
        
        // save credentials
        userDefaults.set(email, forKey: emailKey)
        userDefaults.set(password, forKey: passwordKey)
        userDefaults.set(true, forKey: isLoggedInKey)
        
        // update state
        isLoggedIn = true
        currentUserEmail = email
        
        return true
    }
    
    // login function checks credentials
    func login(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else { return false }
        
        let savedEmail = userDefaults.string(forKey: emailKey) ?? ""
        let savedPassword = userDefaults.string(forKey: passwordKey) ?? ""
        
        // check if credentials match
        if email == savedEmail && password == savedPassword {
            userDefaults.set(true, forKey: isLoggedInKey)
            isLoggedIn = true
            currentUserEmail = email
            return true
        }
        
        return false
    }
    
    // check if user exists
    private func userExists(email: String) -> Bool {
        let savedEmail = userDefaults.string(forKey: emailKey) ?? ""
        return savedEmail == email
    }
    
    // email validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // get error message for signup failures
    func getSignUpError(email: String, password: String) -> String {
        if email.isEmpty { return "Please enter an email" }
        if password.isEmpty { return "Please enter a password" }
        if !isValidEmail(email) { return "Please enter a valid email address" }
        if password.count < 6 { return "Password must be at least 6 characters" }
        if userExists(email: email) { return "An account with this email already exists" }
        return "Unknown error occurred"
    }
    
    // get error message for login failures
    func getLoginError(email: String, password: String) -> String {
        if email.isEmpty { return "Please enter your email" }
        if password.isEmpty { return "Please enter your password" }
        return "Invalid email or password"
    }
}
