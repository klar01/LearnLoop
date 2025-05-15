//
//  Settings.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 5/11/25.
//

import SwiftUI

struct Settings: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var userManager = UserManager()
    @State private var shouldNavigateToRoot = false
    @State private var showDeleteAlert = false
    
    // Computed property to extract username from email
    private var username: String {
        let email = userManager.currentUserEmail
        if let atIndex = email.firstIndex(of: "@") {
            return "@" + String(email[..<atIndex])
        }
        return "@user"
    }
    
    var body: some View{
        NavigationStack{
            ZStack {
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                // Content
                VStack (spacing: 20){
                    HStack{
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .cornerRadius(10)
                                .background(Color(red: 218/255, green: 143/255, blue: 255))
                        }
                        .cornerRadius(10)
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                    }
                    
                    
                    
                    Text("Settings")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    // personal details
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 58/255, green: 58/255, blue: 60/255))
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                        
                        VStack(spacing: 0) {
                            //username - using the extracted username from email
                            settingDetail(mainText: "Username", secondaryText: username)
                            //email - using the current user's email
                            settingDetail(mainText: "Email", secondaryText: userManager.currentUserEmail)
                            // password
                            settingDetail(mainText: "Password")
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: UIScreen.main.bounds.width - 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.vertical, 20)

                    
                    // buttons
                    VStack (spacing: 20){
                        // log out
                        Button(action: {
                            userManager.logout()
                            // Set flag to navigate to root view
                            shouldNavigateToRoot = true
                        }) {
                           Text("Log out")
                                .padding()
                                .foregroundColor(.black)
                                .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                .fontWeight(.bold)
                                .cornerRadius(10)
                                .background(Color(red: 218/255, green: 143/255, blue: 255))
                        }
                        .cornerRadius(10)
                        
                        // delete
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                           Text("Delete Account")
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                .fontWeight(.bold)
                                .cornerRadius(10)
                                .background(Color.red)
                        }
                        .cornerRadius(10)
                        
                    }
                    
                    Spacer()

                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Load the user state when the view appears
            userManager.loadUserState()
        }
        // Navigate back to ContentView when shouldNavigateToRoot is true
        .fullScreenCover(isPresented: $shouldNavigateToRoot) {
            ContentView()
        }
        // Delete account confirmation alert
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                userManager.deleteAccount()
                shouldNavigateToRoot = true
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone. All your flashcard sets will be permanently deleted.")
        }
    }
    
    func settingDetail(mainText: String, secondaryText: String? = nil) -> some View {
        Button(action: {
            
        }) {
            VStack(alignment: .leading){
                
                Text(mainText)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                if let secondary = secondaryText {
                    Spacer()
                    Text(secondary)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(height: 70)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            
        }.buttonStyle(.plain) // prevents the dark dimming effect when pressed
        
    }

}


#Preview{
    Settings()
}
