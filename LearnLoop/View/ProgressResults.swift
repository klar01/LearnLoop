//
//  ProgressResults.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/4/25.
//

import SwiftUI
import SDWebImageSwiftUI
import ConfettiSwiftUI

struct ProgressResults: View{
    @State private var confettiCounter = 0
    
    @ObservedObject var viewModel: FlashcardSetViewModel
    //@State var flashCardSet:
    
    var indexOfSet: Int
    var mode: FlashCardSet.StudyMode
    var clickMasteredButton: Bool = false
    var clickLearningButton: Bool = false
    
    @State private var selectedState: String = "Learning" // Track which button is selected
    
    var isAllMastered: Bool {
        viewModel.getTotalMasteredSessionCards(indexOfSet: indexOfSet) == viewModel.getTotalSessionCards(indexOfSet: indexOfSet)
    }
    
    
    
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
                        
                        if isAllMastered {
                            VStack {
                                WebImage(url: URL(string: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExd2E0bG52ZmhxcHl3a2d6aWh4Y2ZvMGtldnZ4NWJ4dzBmYzU1MXIxbyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/f6v1HAqfj2svgGAqh9/giphy.gif"))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 200)
                                    .cornerRadius(15)
                                    .padding()
                                
                                Text("You're officially a pro!")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                                    .padding(.bottom, 20)
                            }
                            .onAppear {
                                confettiCounter += 1
                            }
                            .confettiCannon(trigger: $confettiCounter)
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        HStack{
                            // Restudy all the flashcards with shuffling
                            restudyButton(
                                text: "ALL cards",
                                destination: StudyMode(viewModel: viewModel, indexOfSet: indexOfSet, mode: .fullSet)
                      
                            )
                            
                            if(viewModel.getTotalUnmasteredSessionCards(indexOfSet: indexOfSet) != 0){
                                
                                // Restudy ONLY the LEARNING flashcards
                                restudyButton(
                                    text: "\(viewModel.getTotalUnmasteredSessionCards(indexOfSet: indexOfSet)) unmastered",
                                    destination: StudyMode(viewModel: viewModel, indexOfSet: indexOfSet, mode: .unmasteredOnly)
                                )
                                
                            }
                            
                            
                        }
                        
                        
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
    var milestones: [Double] {
        let totalCards = viewModel.getTotalSessionCards(indexOfSet: indexOfSet)
        return totalCards < 10 ? [0, 0.5, 1] : [0, 0.25, 0.5, 0.75, 1]
    }
    
    var visualProgress: some View{
        VStack{
            Text("Progress Breakdown").padding()
                .foregroundColor(.white).fontWeight(.bold)
            if mode != .fullSet {
                VStack (alignment: .leading, spacing: 0){
                    Text("Overall Set:").foregroundColor(.white).fontWeight(.semibold)
                                        
                    MilestoneProgressBar(
                        progress: CGFloat(viewModel.progressForOverallMastery(for: indexOfSet)),
                        milestones: milestones
                    )
                    
                }
                .padding()
                .padding(.bottom, 70) // spacing between progress bars
            }
            
            VStack (alignment: .leading, spacing: 2){
                Text("Session Progress: \(mode == .fullSet ? "full set" : "unmastered set")")
                    .foregroundColor(.white).fontWeight(.semibold).padding(.horizontal)
                
                HStack{
                    // Circle Progess Bar
                    ZStack {
                        // Background Circle (Track)
                        Circle()
                            .stroke(lineWidth: 10)
                            .foregroundColor(Color.white.opacity(0.3))
                        
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(viewModel.getSessionProgress(indexOfSet: indexOfSet, mode: mode))) // Trims the circle based on the progress value
                            .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.yellow)
                            .rotationEffect(.degrees(-90)) // Rotate to start the progress from the top
                        
                        
                        // Percentage Text
                        let roundedProgress = round(viewModel.getSessionProgress(indexOfSet: indexOfSet, mode: mode) * 100) / 100
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
                            Text("\(viewModel.getTotalMasteredSessionCards(indexOfSet: indexOfSet))").padding().fontWeight(.semibold).font(.caption)
                        }
                        .background(Color(red: 144/255, green: 238/255, blue: 144/255))
                        .cornerRadius(15)
                        .padding(.trailing, 5)
                        
                        
                        // number of card still learning
                        HStack{
                            Text("Still Learning").padding().fontWeight(.semibold).font(.caption)
                            Spacer()
                            Text("\(viewModel.getTotalUnmasteredSessionCards(indexOfSet: indexOfSet))").padding().fontWeight(.semibold).font(.caption)
                        }.background(Color(red: 255, green: 127/255, blue: 127/255))
                            .cornerRadius(15)
                            .padding(.trailing, 5)
                        
                        
                        // total questions
                        HStack{
                            Text("Total").padding().fontWeight(.semibold).font(.caption)
                            Spacer()
                            Text("\(viewModel.getTotalSessionCards(indexOfSet: indexOfSet))").padding().fontWeight(.semibold).font(.caption)
                        }.foregroundColor(.white)
                            .padding(.trailing, 5)
                    }
                    
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
    
    
//    #Preview {
//        ProgressResultsPreviewWrapper()
//    }
//    
//    struct ProgressResultsPreviewWrapper: View {
//        @StateObject private var viewModel = FlashcardSetViewModel()
//        
//        init() {
//            let sampleSet = FlashCardSet(title: "Sample Set", flashcards: [
//                Flashcard(q: "What is Swift?", a: "A programming language"),
//                Flashcard(q: "What is 2 + 2?", a: "4"),
//                Flashcard(q: "color of sky?", a: "blue"),
//                Flashcard(q: "my name?", a: "some name"),
//                Flashcard(q: "What is 2 + 2?", a: "4"),
//                Flashcard(q: "color of grass?", a: "green"),
//                Flashcard(q: "u like jazz?", a: "no"),
//            ])
//            viewModel.flashcardSet.append(sampleSet)
//        }
//        
//        var body: some View {
//            ProgressResults(viewModel: viewModel, indexOfSet: 0)
//        }
//    }
   
}
