//
//  HomeScreen.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel: FlashcardSetViewModel
    @State private var cardSetTitle: String = ""     // For the search bar
    @State private var searchedSet: FlashCardSet? = nil  // Store the found set
    @State private var index: Int? = nil  // Store the index of the found set
    @State private var resetSearch: Bool = false
    
    var body: some View {
        
        NavigationView{
            ZStack {
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                VStack (spacing: 20){
                    Text("What are we studying today?")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    // Search bar
                    searchBar
                    
                    // Show ONLY searched set if found
                    if let set = searchedSet {
                        Spacer()
                        IndividualSet(viewModel: viewModel, title: set.title, index: index ?? 0)
                        Spacer()
                        
                    } else {
                        // Display an error message if the set is not found
                        if !cardSetTitle.isEmpty {
                            Text("Flashcard set '\(cardSetTitle)' does not exist")
                                .foregroundColor(.red)
                        }
                        
                        // Displays all of user's flashcard set`
                        flashcardSetsList
                    }
                    
                    // navigate to the screen to create a flashcard set
                    NavigationLink(destination: CreateFlashCardSet(viewModel: viewModel)) {
                        Text("Create Set").padding()
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .frame(maxWidth: UIScreen.main.bounds.width - 40)
                            .background(Color(red: 218/255, green: 143/255, blue: 255))
                    }.cornerRadius(10)
                    

                }.padding()
   
            }

        }.navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: - SUBVIEWS
    // search bar
    var searchBar : some View{
        HStack{
            Image(systemName: "magnifyingglass")
                .fontWeight(.black)
                .foregroundColor(.white)
                .padding()
            
            TextField("", text: $cardSetTitle, prompt: Text("Search").foregroundColor(.white)
            )
            .onSubmit {
                // Handle search submission
                if let foundIndex = submitSearchEntry(title: cardSetTitle) {
                    // Update when the index is found
                    index = foundIndex
                    searchedSet = viewModel.flashcardSet[foundIndex]
                } else {
                    // Reset the state if no set is found
                    index = nil
                    searchedSet = nil
                }
            }
            .autocapitalization(.none) // Prevents automatic capitalization
            .foregroundColor(.white)
            .padding(.trailing, 20) // Adds padding to the right
            
            Button(action: {
                cardSetTitle = ""
                index = nil
                searchedSet = nil
                
            }){
                Image(systemName: "clear.fill")
                    .font(.system(size: 20)) // Adjust the size here
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .padding()
                
            }
            
        }
        .cornerRadius(10)
        .background(Color(red: 58/255, green: 58/255, blue: 60/255))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
    }
    
    func submitSearchEntry(title: String) -> Int? {
        if let index = viewModel.flashcardSet.firstIndex(where: { $0.title.lowercased() == title.lowercased() }) {
            return index
        } else {
            return nil
        }
    }
    
    // flashcard sets 
    var flashcardSetsList: some View{
        ScrollView {
            //Flashcard Sets --- Needs to be edited!!!
            VStack{
                // Display default message when there are no flashcard sets
                if(viewModel.flashcardSet.isEmpty){
                    Text("No flashcards yet, create a set!")
                        .foregroundColor(.white)
                }
                
                // Display all flashcard sets
                ForEach(viewModel.flashcardSet.indices, id: \.self) { index in
                    NavigationLink(destination: StudySet(viewModel: viewModel, flashCardSet: viewModel.flashcardSet[index], indexOfSet: index)) {
                        
                        // displays the set name and its progress mastery bar 
                        IndividualSet(viewModel: viewModel, title: viewModel.flashcardSet[index].title, index: index)
                        
                    }
                    
                }
                 
            }
            
        }
    }
}

#Preview {
    HomeScreen(viewModel: FlashcardSetViewModel())
}

