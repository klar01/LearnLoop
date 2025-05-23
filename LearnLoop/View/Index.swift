//
//  Index.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

import SwiftUI

struct Index: View {
    @StateObject private var userManager = UserManager()
    @StateObject private var viewModel = FlashcardSetViewModel()
    
    var body: some View {
        
        NavigationView{
            ZStack {
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                // Content on top of the background
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
                        NavigationLink(destination: LogIn(viewModel: viewModel, userManager: userManager)) {
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
                        NavigationLink(destination: SignUp(viewModel: viewModel, userManager: userManager)) {
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
        .onAppear {
            // Connect the userManager to the viewModel
            viewModel.userManager = userManager
        }
        
    }
}

#Preview {
    Index()
}
