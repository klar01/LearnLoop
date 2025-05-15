//
//  SignUp.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

import SwiftUI

struct SignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSignedUp: Bool = false
    
    @ObservedObject var viewModel: FlashcardSetViewModel
    @ObservedObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background Color
            Color(red: 28/255, green: 28/255, blue: 30/255)
                .edgesIgnoringSafeArea(.all) // Color the entire screen
            
            if isSignedUp {
                // Show HomeScreen with sliding transition from bottom
                HomeScreen(viewModel: viewModel)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                // Sign up form
                VStack{
                    Text("Sign Up").font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(Color.white)
                    
                    Text("Welcome, let's study hard!")
                        .foregroundColor(.white)
                        .padding()
                    
                    // user input
                    VStack(spacing: 20){ // adds spacing between elements
                        // Email input field
                        TextField("", text: $email, prompt: Text("Email").foregroundColor(.white)
                        )
                            .keyboardType(.emailAddress) // Helps with the email input
                            .autocapitalization(.none) // Prevents automatic capitalization
                            .padding()
                            .background(Color(red: 58/255, green: 58/255, blue: 60/255))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                        
                        
                        // Password input field
                        SecureField("", text: $password, prompt: Text("Password (min 6 characters)").foregroundColor(.white)
                        )
                            .padding()
                            .background(Color(red: 58/255, green: 58/255, blue: 60/255))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))

                        
                        // Sign Up button
                        Button(action: {
                            if userManager.signUp(email: email, password: password) {
                                // Connect the userManager to the viewModel and load flashcards
                                viewModel.userManager = userManager
                                viewModel.loadFlashcardsForUser()
                                
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    isSignedUp = true
                                }
                                print("Account created successfully for: \(email)")
                            } else {
                                alertMessage = userManager.getSignUpError(email: email, password: password)
                                showAlert = true
                                print("Signup failed: \(alertMessage)")
                            }
                        }) {
                            HStack {
                                Text("Sign Up")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "person")
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .cornerRadius(10)
                        .background(.red)
                        
                    }.padding()
                    
                    
                    // Navigate to LogIn
                    HStack{
                        Text("Have an account?")
                            .foregroundColor(.white)
                        NavigationLink(destination: LogIn(viewModel: viewModel, userManager: userManager)) {
                            Text("Log In")
                                .foregroundColor(.white)
                                .underline()
                        }
                        
                    }
                        
                    
                }
                .transition(.opacity)
            }
        }
        .alert("Sign Up Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    SignUp(viewModel: FlashcardSetViewModel(), userManager: UserManager())
}
