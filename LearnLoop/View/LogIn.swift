//
//  LogIn.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//
import SwiftUI

struct LogIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoggedIn: Bool = false
    
    @ObservedObject var viewModel: FlashcardSetViewModel
    @ObservedObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if isLoggedIn {
            // Show HomeScreen with sliding transition from bottom
            HomeScreen(viewModel: viewModel)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .bottom)
                ))
        } else {
            ZStack {
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                // Login form
                VStack{
                    Text("Log In").font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(Color.white)
                    
                    Text("Welcome back!")
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
                        SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white)
                        )
                            .padding()
                            .background(Color(red: 58/255, green: 58/255, blue: 60/255))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))

                        
                        // Log In button
                        Button(action: {
                            if userManager.login(email: email, password: password) {
                                // Connect the userManager to the viewModel and load flashcards
                                viewModel.userManager = userManager
                                viewModel.loadFlashcardsForUser()
                                
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    isLoggedIn = true
                                }
                                print("Login successful for: \(email)")
                            } else {
                                alertMessage = userManager.getLoginError(email: email, password: password)
                                showAlert = true
                                print("Login failed for: \(email)")
                            }
                        }) {
                            HStack {
                                Text("Log In")
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
                    
                    
                    // Navigate to SignUp
                    HStack{
                        Text("Need an account?")
                            .foregroundColor(.white)
                        NavigationLink(destination: SignUp(viewModel: viewModel, userManager: userManager)) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .underline()
                        }
                        
                    }
                        
                    
                }
                .transition(.identity)
            }
            .alert("Login Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

#Preview {
    LogIn(viewModel: FlashcardSetViewModel(), userManager: UserManager())
}
