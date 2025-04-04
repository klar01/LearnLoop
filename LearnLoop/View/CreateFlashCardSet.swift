//
//  CreateFlashCardSet.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

// NEED to remove flashcards, 

import SwiftUI

struct CreateFlashCardSet: View {
    @ObservedObject var viewModel: FlashcardSetViewModel
    @State private var title: String  = ""
    @State private var question: String  = ""
    @State private var answer: String  = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    
    // Initially have 2 cards
    @State private var flashcards: [Flashcard] = [
        Flashcard(q: "", a: ""),
        Flashcard(q: "", a: "")
    ]
    
    // Get the presentation mode to dismiss the view when the user is done
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View  {
        ZStack {
            // Background Color
            Color(red: 28/255, green: 28/255, blue: 30/255)
                .edgesIgnoringSafeArea(.all) // Color the entire screen
            
            VStack{
                // Naming Flashcard Set
                namingTitle
                
                // Flashcards set
                flashcardList
                
                
                // Show error message if the flashcard set isn't valid
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                                
                //Create the Flashcard Set
                createFlashcardSetButton
                
            }.padding()
            
           
        }.navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: - SUBVIEWS
    
    var namingTitle: some View {
        HStack{
            TextField("", text: $title, prompt: Text("Name Set").foregroundColor(.white)
            )
                .keyboardType(.emailAddress) // Helps with the email input
                .autocapitalization(.none) // Prevents automatic capitalization
                
                .foregroundColor(.white)
                .padding(.leading, 10)
                .padding(.trailing, 20) // Adds padding to the right
            
            
        }.padding()
        .cornerRadius(10)
        .background(Color(red: 58/255, green: 58/255, blue: 60/255))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
    }
    
    var flashcardList: some View {
        ScrollView {
            // individual cards
            VStack{
                ForEach(flashcards.indices, id: \.self) { index in
                    // Input Fields for Question and Answer
                    VStack {
                        
                        // Question
                        VStack{
                            // prompt
                            HStack{
                                Text("Question")
                                    .foregroundColor(.gray)
                                    .font(.body)
                                Spacer()
                            }
                            
                            // user input
                            TextEditor(text: $flashcards[index].question)
                                .frame(minHeight: 30)
                                .padding(0)
                                .background(Color.white)
                                .fixedSize(horizontal: false, vertical: true)  // Allow vertical expansion based on content
                            
                            // Bottom border for Question TextField
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                        }
                        
                        // Answer
                        VStack{
                            //prompt
                            HStack{
                                Text("Answer")
                                    .foregroundColor(.gray)
                                    .font(.body)
                                Spacer()
                            }
                            
                            // user input
                            TextEditor(text: $flashcards[index].answer)
                                .frame(minHeight: 30)
                                .padding(0)
                                .background(Color.white)
                                .fixedSize(horizontal: false, vertical: true)  // Allow vertical expansion based on content
                            
                            
                            // Bottom border for Question TextField
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                        }
                       
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Divider between cards
                    Rectangle()
                        .frame(height: 3)
                        .frame(width: 100)
                        .foregroundColor(.white)
                        .padding()
                }
                
            }
            
            // Button to simulate adding a new flashcard
            Button("Add Flashcard") {
                //viewModel.addFlashcard() // Add a new flashcard
                let newCard = Flashcard(q: question, a: answer)
                flashcards.append(newCard)
                
            }
            .padding()
            .cornerRadius(10)
            .foregroundColor(.black)
            .fontWeight(.bold)
            .background(Color(red: 218/255, green: 143/255, blue: 255))
            
        }.padding(.top, 20)
    }
    
    var createFlashcardSetButton: some View{
        Button(action:{
            if(validateFlashcards()){
                // Create a new FlashCardSet and add it to the viewModel
                let newSet = FlashCardSet(title: title, flashcards: flashcards)
                viewModel.addFlashcardSet(newSet)
                
                // Dismiss the current view and go back to HomeScreen
                presentationMode.wrappedValue.dismiss()
            }
            
            
        }){
            Text("Create Set").padding()
                .foregroundColor(.black)
                .fontWeight(.bold)
                .background(Color(red: 218/255, green: 143/255, blue: 255))
        }.cornerRadius(10)
    }
    
    
    // validate the set before creating it
    func validateFlashcards() -> Bool {
        //can't have  title is empty
        if title.isEmpty {
            errorMessage = "The title cannot be empty."
            return false
        }
        
        // can't have less than 2 cards
        if(flashcards.count < 2){
            errorMessage = "Must have at least 2 flashcards in your set."
            return false
            
        } else {
            // each flashcard can't have a blank answer or question
            for card in flashcards {
                if card.question.isEmpty || card.answer.isEmpty {
                    errorMessage = "All questions and answers must be filled in."
                    return false
                }
            }
        }
        
        errorMessage = nil // Clear error if validation passes
        return true
    }
   
    
}

#Preview {
    CreateFlashCardSet(viewModel: FlashcardSetViewModel())
}
