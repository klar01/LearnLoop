//
//  CardView.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/4/25.
//

import SwiftUI

// Display the font and back of card. You can tap card to view asnwer/question
struct CardView: View{
    @ObservedObject var viewModel: FlashcardSetViewModel
    @State var flashCardSet: FlashCardSet
    var indexOfSet: Int
    
    // variables for card animation
    @State private var backDegree = 90.0
    @State private var frontDegree = 0.0
    @State private var isFlipped = false
    let durationAndDelay : CGFloat = 0.3
    
    
    // varaibles for the swipe
    @State private var offset = CGSize.zero
    @State private var color: Color = .white
    
    var body: some View {
        // initally shows the question
        ZStack{
            // show question
            CardFront(degree: $frontDegree, questionText: viewModel.currentQuestion(indexOfSet: indexOfSet), color:color)
            // shows anwser
            CardBack(degree: $backDegree, answerText: viewModel.currentAnswer(indexOfSet: indexOfSet), color:color)
        }
        .background(color)
        // fliping animation
        .onTapGesture {
            flipCard () // tap on card to show question/answer
        }
        // drag gesture for mastery
        .offset(x: offset.width, y:offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    withAnimation{
                        changeColor(width: offset.width)
                    }
                }.onEnded {_ in
                    withAnimation{
                        swipeCard(width: offset.width)
                        changeColor(width: offset.width)
                    }
                }
        )
        
    }
    
    func swipeCard(width: CGFloat){
        switch width {
        // swipe to LEFT if card is UNMASTERED
        case -500...(-150):
            //assign card as UNMASTERED
            viewModel.unmasteredCard(indexOfSet: indexOfSet)
            
            // get the next card set
            viewModel.nextCardInSet(indexOfSet: indexOfSet)
            offset = CGSize(width: -500, height: 0)
            print("NOT mastered")
            
        // swipe to RIGHT if card is MASTERED
        case 150...500:
            //assign card as MASTERED
            viewModel.masteredCard(indexOfSet: indexOfSet)
            
            // get the next card set
            viewModel.nextCardInSet(indexOfSet: indexOfSet)
            print("MASTERED card")
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    func changeColor(width: CGFloat){
        switch width{
        case -500...(-130):
            color = .red
        case 130...500:
            color = .green
        default:
            color = .white
        }
    }
    
    // flip animation of the card
    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            // turn the front card halfway
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            // displays the front card
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
            
        } else {
            //turn the backcard halfway
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            // displays the front card
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
            
        }
    }
}


#Preview {
    // Create a sample FlashcardSet to pass to StudyMode
    let viewModel = FlashcardSetViewModel()
    let sampleSet = FlashCardSet(title: "Sample Set", flashcards: [
        Flashcard(q: "What is Swift?", a: "A programming language"),
        Flashcard(q: "What is 2 + 2?", a: "4"),
        Flashcard(q: "color of sky?", a: "blue"),
        Flashcard(q: "my name?", a: "some name"),
        Flashcard(q: "What is 2 + 2?", a: "4"),
        Flashcard(q: "color of grass?", a: "green"),
        Flashcard(q: "u like jazz?", a: "no"),
    ])
    
    // Return the StudyMode view with both viewModel and sampleSet
    CardView(viewModel: viewModel, flashCardSet: sampleSet, indexOfSet: 0)
}
