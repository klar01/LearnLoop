//
//  LearnLoopTests.swift
//  LearnLoopTests
//
//  Created by Klarissa Navarro on 3/30/25.
//

import XCTest
@testable import LearnLoop

final class LearnLoopTests: XCTestCase {
    
    // Unit Tests variables & function error handling
    
    var userManager: UserManager!
    var flashcardViewModel: FlashcardSetViewModel!
    var createFlashCardSet: CreateFlashCardSet!
    
    override func setUpWithError() throws {
        // Initialize dependencies
        userManager = UserManager()
        flashcardViewModel = FlashcardSetViewModel()
        
        // Initialize CreateFlashCardSet with the view model
        createFlashCardSet = CreateFlashCardSet(viewModel: flashcardViewModel)
    }
    
    override func tearDownWithError() throws {
        userManager = nil
        flashcardViewModel = nil
        createFlashCardSet = nil
    }
    
    // Login Management Tests
    
    // Test sign-up functionality
    func testSignUp_Success() {
        let result = userManager.signUp(email: "test@example.com", password: "password123")
        XCTAssertTrue(result, "Sign-up should be successful.")
        XCTAssertTrue(userManager.isLoggedIn, "User should be logged in after successful sign-up.")
        XCTAssertEqual(userManager.currentUserEmail, "test@example.com", "User email should match after sign-up.")
    }
    
    func testSignUp_EmailAlreadyExists() {
        _ = userManager.signUp(email: "test@example.com", password: "password123")
        let result = userManager.signUp(email: "test@example.com", password: "password123")
        XCTAssertFalse(result, "Sign-up should fail if email already exists.")
    }
    
    func testSignUp_InvalidEmail() {
        let result = userManager.signUp(email: "invalid-email", password: "password123")
        XCTAssertFalse(result, "Sign-up should fail with an invalid email address.")
    }
    
    func testSignUp_ShortPassword() {
        let result = userManager.signUp(email: "test@example.com", password: "short")
        XCTAssertFalse(result, "Sign-up should fail with a password less than 6 characters.")
    }
    
    // Test login functionality
    func testLogin_Success() {
        _ = userManager.signUp(email: "test@example.com", password: "password123")
        let result = userManager.login(email: "test@example.com", password: "password123")
        XCTAssertTrue(result, "Login should be successful with correct credentials.")
        XCTAssertTrue(userManager.isLoggedIn, "User should be logged in after successful login.")
    }
    
    func testLogin_Failure() {
        _ = userManager.signUp(email: "test@example.com", password: "password123")
        let result = userManager.login(email: "test@example.com", password: "wrongpassword")
        XCTAssertFalse(result, "Login should fail with incorrect password.")
    }
    
    // Test logout functionality
    func testLogout() {
        _ = userManager.signUp(email: "test@example.com", password: "password123")
        userManager.logout()
        XCTAssertFalse(userManager.isLoggedIn, "User should be logged out.")
        XCTAssertEqual(userManager.currentUserEmail, "", "User email should be cleared after logout.")
    }
    
    // Test account deletion functionality
    func testDeleteAccount() {
        _ = userManager.signUp(email: "test@example.com", password: "password123")
        userManager.deleteAccount()
        XCTAssertFalse(userManager.isLoggedIn, "User should be logged out after account deletion.")
        XCTAssertEqual(userManager.currentUserEmail, "", "User email should be cleared after account deletion.")
        
        // Verify that UserDefaults no longer contains user data
        let savedEmail = UserDefaults.standard.string(forKey: "SavedEmail")
        let savedPassword = UserDefaults.standard.string(forKey: "SavedPassword")
        let isLoggedIn = UserDefaults.standard.bool(forKey: "IsLoggedIn")
        
        XCTAssertNil(savedEmail, "Email should be removed from UserDefaults after account deletion.")
        XCTAssertNil(savedPassword, "Password should be removed from UserDefaults after account deletion.")
        XCTAssertFalse(isLoggedIn, "User should be logged out after account deletion.")
    }
    
    // Test getSignUpError functionality
    func testGetSignUpError() {
        let error = userManager.getSignUpError(email: "", password: "password123")
        XCTAssertEqual(error, "Please enter an email", "Sign-up should fail when email is empty.")
        
        let error2 = userManager.getSignUpError(email: "test@example.com", password: "")
        XCTAssertEqual(error2, "Please enter a password", "Sign-up should fail when password is empty.")
        
        let error3 = userManager.getSignUpError(email: "invalid-email", password: "password123")
        XCTAssertEqual(error3, "Please enter a valid email address", "Sign-up should fail with invalid email format.")
        
        let error4 = userManager.getSignUpError(email: "test@example.com", password: "short")
        XCTAssertEqual(error4, "Password must be at least 6 characters", "Sign-up should fail when password is too short.")
    }
    
    // Test getLoginError functionality
    func testGetLoginError() {
        let error = userManager.getLoginError(email: "", password: "password123")
        XCTAssertEqual(error, "Please enter your email", "Login should fail when email is empty.")
        
        let error2 = userManager.getLoginError(email: "test@example.com", password: "")
        XCTAssertEqual(error2, "Please enter your password", "Login should fail when password is empty.")
        
        let error3 = userManager.getLoginError(email: "test@example.com", password: "wrongpassword")
        XCTAssertEqual(error3, "Invalid email or password", "Login should fail with incorrect credentials.")
    }
    
    // MARK: - Flashcard Creation & Mastery Tests
    
    
    func testCreateFlashcardSet_ValidData() {
        let flashcards: [Flashcard] = [
            Flashcard(q: "What is Swift?", a: "A programming language")
        ]
        
        let validTitle = "Test Set"
        
        flashcardViewModel.addFlashcardSet(FlashCardSet(title: validTitle, flashcards: flashcards))
        
        //        // Check if flashcard set is added
        //        XCTAssertEqual(flashcardViewModel.flashcardSets.count, 1, "Flashcard set should be added.")
        //        XCTAssertEqual(flashcardViewModel.flashcardSets.first?.title, validTitle, "Flashcard set should have the correct title.")
        //        XCTAssertEqual(flashcardViewModel.flashcardSets.first?.flashcards.count, 1, "Flashcard set should have 1 flashcard.")
        //    }
        //
        //    func testCreateFlashcardSet_InvalidData() {
        //        let flashcards: [Flashcard] = []  // No flashcards
        //        let invalidTitle = ""  // Empty title
        //
        //        // Try to create flashcard set with invalid data
        //        flashcardViewModel.addFlashcardSet(FlashCardSet(title: invalidTitle, flashcards: flashcards))
        //
        //        // Assert no sets are created with invalid data
        //        XCTAssertEqual(flashcardViewModel.flashcardSets.count, 0, "Flashcard set should not be created with invalid data.")
        //    }
        //
        //    // Testing Flashcard Add/Remove
        //    // Test title and flashcard validation (empty title or flashcards)
        //    func testCreateFlashcardSet_InvalidTitle() {
        //        createFlashCardSet.title = ""  // Empty title
        //        createFlashCardSet.flashcards = [Flashcard(q: "What is Swift?", a: "A programming language")]
        //
        //        // Trigger create action
        //        createFlashCardSet.createFlashcardSetButton.action?()
        //
        //        XCTAssertNotNil(createFlashCardSet.errorMessage, "Error message should appear if title is empty.")
        //    }
        //
        //    func testCreateFlashcardSet_InvalidFlashcards() {
        //        createFlashCardSet.title = "Test Set"  // Valid title
        //        createFlashCardSet.flashcards = []  // No flashcards
        //
        //        // Trigger create action
        //        createFlashCardSet.createFlashcardSetButton.action?()
        //
        //        XCTAssertNotNil(createFlashCardSet.errorMessage, "Error message should appear if no flashcards are added.")
        //    }
        //
        //    func testCreateFlashcardSet_Success() {
        //        createFlashCardSet.title = "Test Set"  // Valid title
        //        createFlashCardSet.flashcards = [Flashcard(q: "What is Swift?", a: "A programming language")]
        //
        //        // Trigger create action
        //        createFlashCardSet.createFlashcardSetButton.action?()
        //
        //        XCTAssertNil(createFlashCardSet.errorMessage, "Error message should be nil if title and flashcards are valid.")
        //        XCTAssertEqual(flashcardViewModel.flashcardSets.count, 1, "Flashcard set should be added to the view model.")
        //        XCTAssertEqual(flashcardViewModel.flashcardSets.first?.title, "Test Set", "The title of the first set should be 'Test Set'.")
        //        XCTAssertEqual(flashcardViewModel.flashcardSets.first?.flashcards.count, 1, "The flashcard set should contain 1 flashcard.")
        //    }
        //
        //    // Test flashcard deletion
        //    func testDeleteFlashcard() {
        //        createFlashCardSet.title = "Test Set"
        //        createFlashCardSet.flashcards = [
        //            Flashcard(q: "What is Swift?", a: "A programming language"),
        //            Flashcard(q: "What is Xcode?", a: "An IDE for Swift development")
        //        ]
        //
        //        let initialCount = createFlashCardSet.flashcards.count
        //
        //        // Remove one flashcard
        //        createFlashCardSet.flashcards.remove(at: 0)
        //
        //        XCTAssertEqual(createFlashCardSet.flashcards.count, initialCount - 1, "One flashcard should be deleted.")
        //    }
        //
        //    // Test adding a flashcard
        //    func testAddFlashcard() {
        //        createFlashCardSet.flashcards = [
        //            Flashcard(q: "What is Swift?", a: "A programming language")
        //        ]
        //
        //        let initialCount = createFlashCardSet.flashcards.count
        //
        //        // Add a new flashcard
        //        createFlashCardSet.flashcards.append(Flashcard(q: "What is Xcode?", a: "An IDE for Swift development"))
        //
        //        XCTAssertEqual(createFlashCardSet.flashcards.count, initialCount + 1, "Flashcard count should increase by 1 after adding a new flashcard.")
        //    }
        
    }
}
