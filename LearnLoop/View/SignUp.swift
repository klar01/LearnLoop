//
//  Untitled.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

import SwiftUI

struct SignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                VStack{
                    Text("Sign Up").font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(Color.white)
                    
                    Text("Welcome, let’s study hard!")
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

                        
                        // Sin Up button
                        Button(action:{
                            // need to change the action!!!!
                            print("SIGN UP Button tapped!")
                        }) {
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
                        .cornerRadius(10)
                        .background(.red)
                        
                    }.padding()
                    
                    
                    // Navigate to LogIn
                    HStack{
                        Text("Have an account?")
                            .foregroundColor(.white)
                        NavigationLink(destination: LogIn()) {
                            Text("Log In")
                                .foregroundColor(.white)
                                .underline()
                        }
                        
                    }
                        
                    
                }
                
            }
            
        }.navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    SignUp()
}
