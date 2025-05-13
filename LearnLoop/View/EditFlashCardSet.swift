//
//  EditFlashCardSet.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/13/25.
//
import SwiftUI

struct EditFlashCardSet: View {
    @ObservedObject var viewModel: FlashcardSetViewModel
    var indexOfSet: Int
    
    @State private var title: String
    @State private var flashcards: [Flashcard]
    var onSave: (() -> Void)? = nil
    
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    
    //@State private var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: FlashcardSetViewModel, indexOfSet: Int, onSave: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.indexOfSet = indexOfSet
        self.onSave = onSave
        let set = viewModel.flashcardSet[indexOfSet]
        
        _title = State(initialValue: set.title)
        _flashcards = State(initialValue: set.flashcards)
    }

    
    // allows to safely extract the existing flashcard set’s data and assign it to the @State variables
    init(viewModel: FlashcardSetViewModel, indexOfSet: Int) {
        self.viewModel = viewModel
        self.indexOfSet = indexOfSet
        let set = viewModel.flashcardSet[indexOfSet]
        
        _title = State(initialValue: set.title)
        _flashcards = State(initialValue: set.flashcards)
    }
    
    var body: some View {
        
        ZStack {
            // Background Color
            Color(red: 28/255, green: 28/255, blue: 30/255)
                .edgesIgnoringSafeArea(.all) // Color the entire screen
            
            VStack{
                returnbButton
                
                // flashcard set -- title and cards
                FlashcardEditorView(title: $title, flashcards: $flashcards)
                
                // Show error message if the flashcard set isn't valid
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // edit flashcard set
                editButton
                
            }.padding()
            
        }.navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: - SUBVIEWS
    
    var returnbButton: some View {
        HStack{
            NavigationLink(
                destination: StudySet(
                    viewModel: viewModel,
                    
                    indexOfSet: indexOfSet)
            ) {
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
    
    
    var editButton: some View{
        VStack{
            // Divider to separate the content
            Divider().frame(height: 2)  // Adjust the thickness of the divider
                .background(Color.gray)  // Change the divider color to red
   
            Button(action:{
                // display error if the set is missing something
                if let error = FlashcardValidator.validateFlashcards(title: title, flashcards: flashcards) {
                    errorMessage = error
                }
                // no error -- edit set and return to home screen
                else{
                    errorMessage = nil
                    // edits the umastered card list & mastsered card list too
                    viewModel.updateFlashcardSet(at: indexOfSet, newTitle: title, newFlashcards: flashcards)
                    
                    onSave?() // triggers the reloadID change
                    
                    // Dismiss the current view and go back to HomeScreen
                    presentationMode.wrappedValue.dismiss()
                }
            }){
                Text("Edit Set").padding()
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .background(Color(red: 218/255, green: 143/255, blue: 255))
            }.cornerRadius(10)

        }
        
    }

    
}

#Preview {
    let viewModel = FlashcardSetViewModel()
    viewModel.flashcardSet = [
        FlashCardSet(title: "Sample Set", flashcards: [
            Flashcard(q: "What is Swift?", a: "A programming language"),
            Flashcard(q: "What is 2 + 2?", a: "4"),
            Flashcard(q: "What is the capital of France?", a: "Paris")
        ])
    ]
    
    return EditFlashCardSet(viewModel: viewModel, indexOfSet: 0)
}

