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
                returnHomeScreen
                
                // flashcard set -- title and cards
                FlashcardEditorView(title: $title, flashcards: $flashcards) // Flashcards set

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
    
    var returnHomeScreen: some View{
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
            Spacer()
 
        }.padding(.bottom, 5)
    
    }
    
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
        ScrollViewReader { proxy in
            // created list instead of ScrollView b/c it will be easier to remove the card if you swipe
            List {
                ForEach(flashcards.indices, id: \.self) { index in
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            // Question
                            VStack(alignment: .leading) {
                                Text("Question")
                                    .foregroundColor(.gray)
                                    .font(.body)
                                TextEditor(text: $flashcards[index].question)
                                    .frame(minHeight: 30)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .fixedSize(horizontal: false, vertical: true)  // Allow vertical expansion based on content
                            }
                            
                            // border between question and answer
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                            
                            // Answer
                            VStack(alignment: .leading) {
                                Text("Answer")
                                    .foregroundColor(.gray)
                                    .font(.body)
                                TextEditor(text: $flashcards[index].answer)
                                    .frame(minHeight: 30)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .fixedSize(horizontal: false, vertical: true)  // Allow vertical expansion based on content
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.vertical, 10) // adds spacing between cards
                        
                        // to remove card
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                flashcards.remove(at: index)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        
                        // Divider between cards
                        Rectangle()
                            .frame(height: 3)
                            .frame(width: 100)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .listRowInsets(EdgeInsets()) //remove default padding (ideal width of card)
                    .listRowBackground(Color.clear) // clear backgroundt to show the spacing between cards
                    .id(index) // Assign an id for scroll action
                }
                
                
                // Add Card Button
                Section {
                    Button(action: {
                        flashcards.append(Flashcard(q: "", a: ""))
                        
                        // Scroll to the newly added card
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {  // time to allow for the new card to be added
                            // makes adding the card loook more naturally than appear abruptly
                            withAnimation {
                                proxy.scrollTo("BottomSpacer", anchor: .bottom) // Scroll to "BottomSpacer" element so the card and "add" button are in within view
                            }
                        }
                    }) {
                        HStack {
                            Text("+ Add Flashcard")
                        }
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center) // center the text/icon
                        .padding(.vertical, 10) // creates spacings between cards
                    }
                    .listRowBackground(Color.clear) // transparent background for the list row
                    .listRowInsets(EdgeInsets())    // removes unwanted padding
                    
                    Color.clear
                    .frame(height: 1)
                    .id("BottomSpacer").listRowBackground(Color.clear)
                }
                
                
                
            }
            .listStyle(PlainListStyle())
        }
        
    }
    
    var createFlashcardSetButton: some View{
        VStack{
            // Divider to separate the content
            Divider().frame(height: 2)  // Adjust the thickness of the divider
                .background(Color.gray)  // Change the divider color to red
   
            
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
