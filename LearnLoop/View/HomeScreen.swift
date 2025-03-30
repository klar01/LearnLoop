//
//  HomeScreen.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

import SwiftUI

struct HomeScreen: View {
    
    var body: some View {
        
        NavigationView{
            ZStack {
                // Background Color
                Color.pink
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                // Content on top of the background
                VStack {
                    HStack {
                        Text("LearnLoop")
                            .foregroundColor(.black)
                            .padding()
                        
                        Spacer() // Push the score to the left
                    }
                    
                    // Add other content here
                }
            }
        }
        
    }
}

#Preview {
    HomeScreen()
}

