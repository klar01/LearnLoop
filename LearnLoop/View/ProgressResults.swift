//
//  ProgressResults.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/4/25.
//

import SwiftUI

struct ProgressResults: View{
    @ObservedObject var viewModel: FlashcardSetViewModel
    //@State var flashCardSet:
    
    var indexOfSet: Int
    var clickMasteredButton: Bool = false
    var clickLearningButton: Bool = false
    
    @State private var selectedState: String = "Learning" // Track which button is selected
    
    var body: some View{
        NavigationView{
            ZStack{
                // Background Color
                Color(red: 28/255, green: 28/255, blue: 30/255)
                    .edgesIgnoringSafeArea(.all) // Color the entire screen
                
                VStack{
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
                    }
                    
                    ScrollView{
                        Text("Nice work! Let's keep praticing").padding()
                            .fontWeight(.bold)
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        
                        // button will only appear if the user mastered ALL the cards
//                        if(viewModel.flashcardSet[indexOfSet].masteredCards ==  viewModel.flashcardSet[indexOfSet].total){
                           
                            // Restudy all the flashcards with shuffling
                            restudyButton(
                                text: "Restart Flashcards",
                                destination: StudyMode(viewModel: viewModel, indexOfSet: indexOfSet)
                      
                            )
                            
//                        } else {
                            // Restudy ONLY the LEARNING flashcards
                            restudyButton(
                                text: "Keep Reviewing \(viewModel.flashcardSet[indexOfSet].unMastered) cards",
                                destination: StudyMode(viewModel: viewModel, indexOfSet: indexOfSet)
                            )
//                        }
                        
                        // Visual Progress -- show total number of questions correct/wrong and circle progress bar
                        visualProgress
                        
                        // shows which questions are right/wrong (i.e., displays the list of cards in Leraning or Mastered)
                        displayCards
                        
                    }
                }
                
            }
            
        }.navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: - SUBVIEWS
    // MARK: - restudy button
    func restudyButton(text: String, destination: some View) -> some View {
        
        NavigationLink(destination: destination) {
            Text(text)
                .padding()
                .foregroundColor(.black)
                .fontWeight(.bold)
                .background(Color(red: 218/255, green: 143/255, blue: 255))
                
        }.cornerRadius(10)
    }
    
    // MARK: -  visual results
    var visualProgress: some View{
        VStack{
            Text("Your Progress").padding().fontWeight(.semibold).foregroundColor(.white)
            
            HStack{
                // Circle Progess Bar
                ZStack {
                    // Background Circle (Track)
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color.white.opacity(0.3))
                    
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(viewModel.progressForMastery(for: indexOfSet))) // Trims the circle based on the progress value
                        .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.yellow)
                        .rotationEffect(.degrees(-90)) // Rotate to start the progress from the top
                    
                    
                    // Percentage Text
                    let roundedProgress = round(viewModel.progressForMastery(for: indexOfSet) * 100) / 100
                    Text("\(Int(roundedProgress * 100))%")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 120, height: 120)
                .padding()
                .padding(.bottom, 20)
                
                VStack{
                    // number of card mastered
                    HStack{
                        Text("Mastered").padding().fontWeight(.semibold).font(.caption)
                        Spacer()
                        Text("\(viewModel.flashcardSet[indexOfSet].masteredCards)").padding().fontWeight(.semibold).font(.caption)
                    }
                    .background(Color(red: 144/255, green: 238/255, blue: 144/255))
                    .cornerRadius(15)
                    .padding(.trailing, 5)
                    
                    
                    // number of card still learning
                    HStack{
                        Text("Still Learning").padding().fontWeight(.semibold).font(.caption)
                        Spacer()
                        Text("\(viewModel.flashcardSet[indexOfSet].unMastered)").padding().fontWeight(.semibold).font(.caption)
                    }.background(Color(red: 255, green: 127/255, blue: 127/255))
                        .cornerRadius(15)
                        .padding(.trailing, 5)
                    
                    
                    // total questions
                    HStack{
                        Text("Total").padding().fontWeight(.semibold).font(.caption)
                        Spacer()
                        Text("\(viewModel.flashcardSet[indexOfSet].total)").padding().fontWeight(.semibold).font(.caption)
                    }.foregroundColor(.white)
                        .padding(.trailing, 5)
                }
                
            }
            
        }
        .background(Color(red: 58/255, green: 58/255, blue: 60/255))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
        .padding()
        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5) // Add shadow to "pop" the container forward
    }
    
    // MARK: -  displays the list of cards in Leraning/Mastered
    var displayCards: some View {
        VStack{
            // navigation
            HStack{
                Text("Learning")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(selectedState == "Learning" ? Color.black : Color.white)
                    .padding()
                    .background(selectedState == "Learning" ? Color.yellow : Color.clear)
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedState = "Learning" // Set to Mastered when tapped
                    }
                
                Text("Mastered")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(selectedState == "Mastered" ? Color.black : Color.white)
                    .padding()
                    .background(selectedState == "Mastered" ? Color.yellow : Color.clear)
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedState = "Mastered" // Set to Mastered when tapped
                    }
                
            }.background(Color(red: 58/255, green: 58/255, blue: 60/255))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                .padding()
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5) // Add shadow to "pop" the container forward

            let cards = viewModel.getStudiedCards(indexOfSet: indexOfSet, status: selectedState)
            VStack {
                
                ForEach(cards, id: \.id) { card in
                    cardView(for: card, state: selectedState)
                }
            }
            .padding()
            
        }
    }
    
    // MARK: -  indiviual cards 1-sided
    func cardView(for card: Flashcard, state: String) -> some View {
        VStack {
            // Question
            VStack {
                HStack {
                    Text(card.question)
                        .foregroundColor(.black)
                        .font(.body)
                    Spacer()
                }
                
                // Bottom border for Question TextField
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
            }
            
            // Answer
            VStack {
                HStack {
                    Text(card.answer)
                        .foregroundColor(.black)
                        .font(.body)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 3)
        )
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 3) // Darker shadow for better contrast
        .padding(.bottom, 30)
        
    }
    
    
    #Preview {
        ProgressResultsPreviewWrapper()
    }
    
    struct ProgressResultsPreviewWrapper: View {
        @StateObject private var viewModel = FlashcardSetViewModel()
        
        init() {
            let sampleSet = FlashCardSet(title: "Sample Set", flashcards: [
                Flashcard(q: "What is Swift?", a: "A programming language"),
                Flashcard(q: "What is 2 + 2?", a: "4"),
                Flashcard(q: "color of sky?", a: "blue"),
                Flashcard(q: "my name?", a: "some name"),
                Flashcard(q: "What is 2 + 2?", a: "4"),
                Flashcard(q: "color of grass?", a: "green"),
                Flashcard(q: "u like jazz?", a: "no"),
            ])
            viewModel.flashcardSet.append(sampleSet)
        }
        
        var body: some View {
            ProgressResults(viewModel: viewModel, indexOfSet: 0)
        }
    }
    
}
