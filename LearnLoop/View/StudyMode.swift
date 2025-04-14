//
//  Untitled.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

// User begins studying the entire flashcard set
// card animation
// swiping gestures 
import SwiftUI

struct StudyMode: View{
    // values passed from StudySet
    @ObservedObject var viewModel: FlashcardSetViewModel
    @State var flashCardSet: FlashCardSet
    var indexOfSet: Int
    
    var body: some View{
        ZStack{
            // Background Color
            Color(red: 28/255, green: 28/255, blue: 30/255)
                .edgesIgnoringSafeArea(.all) // Color the entire screen
            
            VStack{
                VStack{
                    Text("Currently studying: \(flashCardSet.title)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
                
                // Progress Bar -- the number of cards left to go through in set
                VStack{
                    Text("\(viewModel.flashcardSet[indexOfSet].cardNumber) / \(flashCardSet.flashcards.count)").foregroundColor(.white).padding()
                    
                    //progress bar
                    ProgressView(value: viewModel.progessOfCardsStudied(for: indexOfSet), total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                        .frame(width: 250)
                  
                }
                
                
                Spacer()

                //Display all cards -- all stacked on top of each other
                ZStack {
                    
                    VStack{
                        Text("Great job!").padding().foregroundColor(.white).fontWeight(.bold)
                        
                        // Navigate back to Progress result screen
                        NavigationLink(destination: ProgressResults(viewModel: viewModel, flashCardSet: flashCardSet, indexOfSet: indexOfSet)) {
                            Text("View Results")
                                .padding()
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .background(Color(red: 218/255, green: 143/255, blue: 255))
                        }
                        .cornerRadius(10)
                        .frame(maxWidth: 200)
                        
                    }
                    
                    ForEach (flashCardSet.flashcards.indices, id: \.self) { index in
                        CardView(viewModel: viewModel, flashCardSet: flashCardSet, indexOfSet: indexOfSet)
                    }
                   
                }
                
            
                Spacer()

                // Navigate back to HomeScreen
                NavigationLink(destination: HomeScreen(viewModel: viewModel)) {
                    Text("Finish Studying")
                        .padding()
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .background(Color(red: 218/255, green: 143/255, blue: 255))
                }
                .cornerRadius(10)
                .frame(maxWidth: 200)
                
            }.padding()
            
        }.navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    // Create a sample FlashcardSet to pass to StudyMode
    let viewModel = FlashcardSetViewModel()
    let sampleSet = FlashCardSet(title: "Sample Set", flashcards: [
        Flashcard(q: "What is Swift?", a: "A programming language"),
        Flashcard(q: "What is 2 + 2?", a: "4"),
        Flashcard(q: "color of sky?", a: "blue"),
        Flashcard(q: "my name?", a: "some name"),
        Flashcard(q: "What is 2 + 2?", a: "4"),
        Flashcard(q: "color of grass?", a: "green"),
        Flashcard(q: "u like jazz?", a: "no"),
    ])
    
    // Return the StudyMode view with both viewModel and sampleSet
    StudyMode(viewModel: viewModel, flashCardSet: sampleSet, indexOfSet: 0)
}
