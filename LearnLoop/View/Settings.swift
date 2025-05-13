//
//  Settings.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 5/11/25.
//

import SwiftUI

struct Settings: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                            //username
                            settingDetail(mainText: "Username", secondaryText: "@john_doe")
                            //email
                            settingDetail(mainText: "Email",secondaryText: "jmpss@gmail.com")
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
                            
                        }) {
                           Text("Delete Account")
                                .padding()
                                .foregroundColor(.black)
                                .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                .fontWeight(.bold)
                                .cornerRadius(10)
                                .background(Color(red: 218/255, green: 143/255, blue: 255))
                        }
                        .cornerRadius(10)
                        
                    }
                    
                    Spacer()

                }
            }
        }.navigationBarBackButtonHidden(true)
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
