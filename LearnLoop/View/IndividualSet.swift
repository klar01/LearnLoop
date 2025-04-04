//
//  IndividualSet.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/3/25.

// resuable component to show the UI of the individual flashcard set
// showing the title and progress bar

import SwiftUI

struct IndividualSet: View{
    var viewModel: FlashcardSetViewModel
    var title: String // Add a property to accept custom text
    var index: Int
    
    var body : some View {
        VStack{
            // title
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title)
                .padding()
                .foregroundColor(.black)
            
            //progress bar
            ProgressView(value: viewModel.progress(for: index), total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                .frame(width: 250)
                .padding()
            
        }
        .frame(minHeight: 150)
        .frame(maxWidth: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.bottom, 20)
    }
}

