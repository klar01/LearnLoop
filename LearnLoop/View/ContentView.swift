//
//  ContentView.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userManager = UserManager()
    @ObservedObject var viewModel = FlashcardSetViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                if userManager.isLoggedIn {
                    // If user is already logged in, go directly to HomeScreen
                    HomeScreen(viewModel: viewModel)
                } else {
                    // If not logged in, show the welcome screen
                    VStack {
                        Text("LearnLoop")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            
                        Text("Welcome, let's study hard!")
                            .foregroundColor(.white)
                            .padding()
                        
                        //button container
                        VStack (spacing: 20){
                            // LOGIN
                            NavigationLink(destination: LogIn(viewModel: viewModel)) {
                                Text("Log In")
                                    .font(.body)
                                    .padding()
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "person")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .cornerRadius(10)
                            .background(Color(red: 58/255, green: 58/255, blue: 60/255))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                       
                            
                            // SIGN UP
                            NavigationLink(destination: SignUp(viewModel: viewModel)) {
                                Text("Sign up")
                                    .font(.body)
                                    .padding()
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "person")
                                    .foregroundColor(.white)
                                    .padding()
                                    
                            }
                            .cornerRadius(10)
                            .background(Color(red: 58/255, green: 58/255, blue: 60/255))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                   
                        }.padding()
                       
                    }
                }
            }
        }
        .onAppear {
            // Load user state when the app starts
            userManager.loadUserState()
        }
    }
}

#Preview {
    ContentView()
}
