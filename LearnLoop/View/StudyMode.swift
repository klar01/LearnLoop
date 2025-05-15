//
//  StudyMode.swift
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
    var indexOfSet: Int
    var mode: FlashCardSet.StudyMode
    @Environment(\.dismiss) private var dismiss
    
    var body: some View{
        // Safety check to ensure index is valid
        if indexOfSet >= 0 && indexOfSet < viewModel.flashcardSet.count {
            let flashcardSet = viewModel.flashcardSet[indexOfSet]
            
            ZStack{
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                VStack{
                    VStack{
                        Text("Currently studying: \(flashcardSet.title)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Progress Bar -- the number of cards left to go through in set
                    VStack{
                        Text("\(flashcardSet.cardNumber) / \(flashcardSet.currentSessionCards.count)").foregroundColor(.white).padding()
                        
                        //progress bar
                        ProgressView(value: viewModel.progessOfCardsStudied(for: indexOfSet), total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                            .frame(width: 250)
                      
                    }
                    
                    
                    Spacer()

                    //Display all cards -- all stacked on top of each other
                    VStack {
                        
                        ZStack{
                            Text("Great job!").padding().foregroundColor(.white).fontWeight(.bold)
                            
                            // Navigate back to Progress result screen
                            NavigationLink(destination: ProgressResults(viewModel: viewModel, indexOfSet: indexOfSet, mode: mode)) {
                                Text("View Results")
                                    .padding()
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .background(Color(red: 218/255, green: 143/255, blue: 255))
                                    
                            }
                            .cornerRadius(10)
                            .frame(maxWidth: 200)
                            
                            ForEach(flashcardSet.currentSessionCards, id: \.id) { card in
                                CardView(viewModel: viewModel, indexOfSet: indexOfSet)
                            }
                           
                        }
                        
                    }.onAppear {
                        // Only set mode if index is still valid
                        if indexOfSet >= 0 && indexOfSet < viewModel.flashcardSet.count {
                            viewModel.setModeSession(indexOfSet: indexOfSet, mode: mode)
                            // guarantees that the progress bar will reset and suffle cards
                            viewModel.suffleCardsInSet(indexOfSet: indexOfSet)
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
                
            }
            .navigationBarBackButtonHidden(true)
            .onReceive(viewModel.$flashcardSet) { flashcardSets in
                // If flashcard sets become empty (e.g., after logout), dismiss this view
                if flashcardSets.isEmpty {
                    dismiss()
                }
            }
        } else {
            // If index is invalid (e.g., after logout), show loading and dismiss
            Color(red: 28/255, green: 28/255, blue: 30/255)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    dismiss()
                }
        }
    }
    
}


#Preview {
    let viewModel: FlashcardSetViewModel = {
        let vm = FlashcardSetViewModel()
        let sampleSet = FlashCardSet(
            title: "Sample Set",
            flashcards: [
                Flashcard(q: "What is Swift?", a: "A programming language"),
                Flashcard(q: "What is 2 + 2?", a: "4"),
                Flashcard(q: "Color of sky?", a: "Blue"),
                Flashcard(q: "My name?", a: "Some name"),
                Flashcard(q: "What is 10?", a: "A number"),
                Flashcard(q: "Color of grass?", a: "Green"),
                Flashcard(q: "U like jazz?", a: "No")
            ]
        )
        vm.flashcardSet.append(sampleSet)
        vm.setModeSession(indexOfSet: 0, mode: .unmasteredOnly) // Simulate session setup
        vm.suffleCardsInSet(indexOfSet: 0) // Shuffle for realism
        return vm
    }()
    
    return StudyMode(viewModel: viewModel, indexOfSet: 0, mode: .unmasteredOnly)
}
