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
//    var flashCardSet: FlashCardSet
    var indexOfSet: Int
    @State private var reloadID = UUID()
    @State private var setTitle: String = ""
    
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
                            // Capture title BEFORE deletion
                            _ = viewModel.flashcardSet[indexOfSet].title
                            
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
                    
                    if let index = viewModel.flashcardSet.firstIndex(where: { $0.title == setTitle }) {
                        IndividualSet(viewModel: viewModel, title: setTitle, index: index)
                    }
                    
                    // Button Container
                    VStack (spacing: 20){
                        HStack{
                            if viewModel.flashcardSet.firstIndex(where: { $0.title == setTitle }) != nil {
                                NavigationLink(destination: StudyMode(viewModel: viewModel, indexOfSet: indexOfSet, mode: .fullSet)) {
                                    Text("Full Set")
                                        .padding()
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                        .cornerRadius(10)
                                        .background(Color(red: 218/255, green: 143/255, blue: 255))
                                    
                                }.cornerRadius(10)
                                
                                if(viewModel.flashcardSet[indexOfSet].unMastered > 0) {
                                    Spacer()
                                    
                                    NavigationLink(destination: StudyMode(viewModel: viewModel, indexOfSet: indexOfSet, mode: .unmasteredOnly)) {
                                        Text("Unmastered Set")
                                            .padding()
                                            .foregroundColor(.black)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                            .cornerRadius(10)
                                            .background(Color(red: 218/255, green: 143/255, blue: 255))
                                        
                                    }.cornerRadius(10)
                                }
                                
                            }
                                
                        }.frame(maxWidth: UIScreen.main.bounds.width - 40)
                        
                        if viewModel.flashcardSet.firstIndex(where: { $0.title == setTitle }) != nil {
                            // Edit set
                            NavigationLink(
                                destination: EditFlashCardSet(
                                viewModel: viewModel,
                                indexOfSet: indexOfSet,
                                onSave: {
                                    reloadID = UUID() //triggers full reload of this view
                                }
                            )) {
                                Text("Edit Set")
                                    .padding()
                                    .foregroundColor(.black)
                                    .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                    .fontWeight(.bold)
                                    .cornerRadius(10)
                                    .background(Color(red: 218/255, green: 143/255, blue: 255))
                                
                            }.cornerRadius(10)
                        }
                        
                    }
                        
                    Spacer()
                }
                .id(reloadID)
                .onAppear {
                    if indexOfSet >= 0 && indexOfSet < viewModel.flashcardSet.count {
                        setTitle = viewModel.flashcardSet[indexOfSet].title
                    }
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
                Flashcard(q: "What is Swift?", a: "A programming language", isMastered: true),
                Flashcard(q: "What is 3 + 1?", a: "4", isMastered: true),
                Flashcard(q: "What is C++?", a: "A programming language", isMastered: true),
                Flashcard(q: "What is blue", a: "a color"),
                Flashcard(q: "What is Swift?", a: "A programming language", isMastered: true),
                Flashcard(q: "What is 2 + 2?", a: "4", isMastered: true),
                Flashcard(q: "What is 3 + 2?", a: "5", isMastered: true),
                Flashcard(q: "like hazz?", a: "no"),
                Flashcard(q: "Want something", a: "nope"),
            ])
        ]
        
        // Return the StudySet view with the viewModel and sample flashCardSet
//        return StudySet(viewModel: viewModel, flashCardSet: viewModel.flashcardSet[0], indexOfSet: 0)
        return StudySet(viewModel: viewModel, indexOfSet: 0)
    }
}

