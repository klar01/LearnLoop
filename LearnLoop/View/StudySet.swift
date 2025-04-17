//
//  StudyModeView.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/2/25.
// 

import SwiftUI

struct StudySet:  View{
    // values are passed from the HomeScreen 
    @ObservedObject var viewModel: FlashcardSetViewModel
    var flashCardSet: FlashCardSet
    var indexOfSet: Int
    
    // Get the presentation mode to dismiss the view when the user is done
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View{
        NavigationStack{
            ZStack {
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                // Content
                VStack {
                    
                    // nav icon to return to HomeScreen
                    HStack{
                        NavigationLink(destination: HomeScreen(viewModel: viewModel)) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .cornerRadius(10)
                                .background(Color(red: 218/255, green: 143/255, blue: 255))
                        }
                        .cornerRadius(10)
                        .padding(.leading, 20) // Add padding to the left side to create spacing from the edge

                        Spacer()
                        
                        // removes the flashcard set
                        Button(action: {
                            // delete set
                            viewModel.removeFlashcardSetByIndex(index: indexOfSet)
                            
                            // Dismiss the current view and go back to HomeScreen
                            presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "trash")
                                .padding()
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .background(Color(red: 218/255, green: 143/255, blue: 255))
                                .cornerRadius(10)
                        }
                        .padding(.trailing, 20)

                    }
                    
                    Spacer()
                    
                    // display the title of flashcard set with its progress bar
                    if let index = viewModel.flashcardSet.firstIndex(where: { $0.title == flashCardSet.title }) {
                        IndividualSet(viewModel: viewModel, title: flashCardSet.title, index: index)
                    }
                    
                    // Button Container
                    VStack (spacing: 20){
                        NavigationLink(destination: StudyMode(viewModel: viewModel, flashCardSet: flashCardSet, indexOfSet: indexOfSet)) {
                            Text("Study Set")
                                .padding()
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                .cornerRadius(10)
                                .background(Color(red: 218/255, green: 143/255, blue: 255))
                                
                        }.cornerRadius(10)
                        
                        // Edit set
                        NavigationLink(destination: EditFlashCardSet(viewModel: viewModel, indexOfSet: indexOfSet)) {
                            Text("Edit Set")
                                .padding()
                                .foregroundColor(.black)
                                .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                .fontWeight(.bold)
                                .cornerRadius(10)
                                .background(Color(red: 218/255, green: 143/255, blue: 255))
                                
                        }.cornerRadius(10)
                        
                    }
                    Spacer()
                }
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
 
    }
    
}


struct StudySetPreview: PreviewProvider {
    static var previews: some View {
        // Create a FlashcardSetViewModel instance for preview
        let viewModel = FlashcardSetViewModel()
        
        // Populate it with a sample flashcard set
        viewModel.flashcardSet = [
            FlashCardSet(title: "Sample Set", flashcards: [
                Flashcard(q: "What is Swift?", a: "A programming language"),
                Flashcard(q: "What is 2 + 2?", a: "4"),
                Flashcard(q: "What is Swift?", a: "A programming language"),
                Flashcard(q: "What is 2 + 2?", a: "4"),
                Flashcard(q: "What is Swift?", a: "A programming language", isMastered: true),
                Flashcard(q: "What is 2 + 2?", a: "4")
            ])
        ]
        
        // Return the StudySet view with the viewModel and sample flashCardSet
        return StudySet(viewModel: viewModel, flashCardSet: viewModel.flashcardSet[0], indexOfSet: 0)
    }
}

