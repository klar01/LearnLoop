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
    
    // dynamically displays the flashcard set(s) based on search input
    var filteredSets: [FlashCardSet] {
        // show all sets if there is no input
        if cardSetTitle.isEmpty {
            return viewModel.flashcardSet
        }
        // show the possible flashcard sets that the user could be looking for based on the input
        else {
            return viewModel.flashcardSet.filter {
                $0.title.lowercased().contains(cardSetTitle.lowercased())
            }
        }
    }
    
    var body: some View {
        
        NavigationView{
            ZStack {
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                VStack (spacing: 20){
    
                    HStack{
                        Text("What are we studying today?")
                            .font(.title3)
                            .foregroundColor(.white)
                        Spacer()
                        
                        NavigationLink(destination: Settings(userManager: viewModel.userManager, viewModel: viewModel)){
                            Image(systemName: "person")
                                .font(.system(size: 28)) // makes image bigger here
                                .fontWeight(.black)
                                .foregroundColor(.black)
                                    
                        }.frame(width: 100, height: 70)
                            .background(.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.purple, lineWidth: 5) // Yellow border
                            )
                            .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                            .padding(.trailing, -15)
                        

                    
                    }.padding(.horizontal)
                    // Search bar
                    searchBar
                    
                    // Show message if no results
                    if filteredSets.isEmpty && !cardSetTitle.isEmpty {
                        Text("No flashcard set found with '\(cardSetTitle)'")
                            .foregroundColor(.red)
                        Spacer()
                        
                    } else {
                        // Show flashcard sets
                        ScrollView {
                            VStack() {
                                
                                ForEach(filteredSets.indices, id: \.self) { index in
                                    if let originalIndex = viewModel.flashcardSet.firstIndex(where: { $0.title == filteredSets[index].title }) {
                                        
                                        // click on a set to either edit or study
                                        NavigationLink(destination: StudySet(viewModel: viewModel,  indexOfSet: index)) {
                                            
                                            // displays the set name and its progress mastery bar
                                            IndividualSet(viewModel: viewModel, title: filteredSets[index].title, index: originalIndex)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    // navigate to the screen to create a flashcard set
                    NavigationLink(destination: CreateFlashCardSet(viewModel: viewModel)) {
                        Text("Create Set").padding()
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .frame(maxWidth: UIScreen.main.bounds.width - 40)
                            .background(Color(red: 218/255, green: 143/255, blue: 255))
                    }.cornerRadius(10)
                    
                    
                }//.padding()
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: - SUBVIEWS
    // MARK: - search bar
    var searchBar : some View{
        HStack{
            Image(systemName: "magnifyingglass")
                .fontWeight(.black)
                .foregroundColor(.white)
                .padding()
            
            TextField("", text: $cardSetTitle, prompt: Text("Search").foregroundColor(.white)
            )
            
            .autocapitalization(.none) // Prevents automatic capitalization
            .foregroundColor(.white)
            .padding(.trailing, 20) // Adds padding to the right
            
            // Clear search input button
            if !cardSetTitle.isEmpty {
                Button(action: {
                    cardSetTitle = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .padding(.trailing)
                }
            }
            
        }
        .cornerRadius(10)
        .background(Color(red: 58/255, green: 58/255, blue: 60/255))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
        .padding()
    }
    
}

#Preview {
    HomeScreen(viewModel: FlashcardSetViewModel())
}
