//
//  FlashcardSetViewModel.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/2/25.
//

import Foundation

// handle the data logic for the flashcard set
class FlashcardSetViewModel: ObservableObject {
    
    // currently has dummy variables
    @Published var flashcardSet: [FlashCardSet] = [
        FlashCardSet(title: "rand title 1", flashcards: [
            Flashcard(q: "some question 1: dhjnj njnj jknnj j d ds hsbh jks sd sd ds hsbh jks sd s hsbhj jks nj jks sd sd ds hsbh nj jks sd sd ds hsbh nj jks sd sd ds hsbh  sd sd ds hsbhs sd sd ds hsbh nj jks s j sh nj j sd ds hsbh jks sd sd ds hsbh jks sd s hsbhj jks nj jks sd sd ds hsbh nj jks sd sd ds hsbh nj jks sd sd ds hsbh  sd sd ds hsbhs sd sd ds hsbh nj jks s j sh nj jks sd sd ds hsbh jks sd sd ds hsbh jks sd sd ds hsbhbjhs", a: "some answer for question 1"),
            Flashcard(q: "QUESTION 2nd", a: "some answer for question 2nd  ds hsbh jks sd sd ds hsbh jks sd s hsbhj jks nj jks sd sd ds hsbh nj jks sd sd ds hsbh nj jks sd sd ds hsbh  sd sd ds hsbhs sd sd ds hsbh nj jks s j sh nj jks sd sd d"),
            Flashcard(q: "What is Swift?", a: "A programming language"),
            Flashcard(q: "What is 2 + 2?", a: "4"),
            Flashcard(q: "color of sky?", a: "blue"),
            Flashcard(q: "my name?", a: "some name"),
            Flashcard(q: "What is 10?", a: "a number"),
            Flashcard(q: "color of grass?", a: "green"),
            Flashcard(q: "u like jazz?", a: "no"),
        ]),
        FlashCardSet(title: "ANOTHER ONE", flashcards: [
            Flashcard(q: "some question 1", a: "some answer for question 1"),
            Flashcard(q: "some question 2nd", a: "some answer for question 2nd")
        ])
    ]
    
    // current question for a specifc flashcard set
    func currentQuestion(indexOfSet: Int) -> String {
        if indexOfSet >= 0 && indexOfSet < flashcardSet.count {
            if let currQuestion = flashcardSet[indexOfSet].getCurrentQuestion() {
                return currQuestion
            } else {
                return "You're done studying!"
            }
        }
        return "Index out of range"
        
    }
    
    // current answer for a specifc flashcard set
    func currentAnswer(indexOfSet: Int) -> String {
        if indexOfSet >= 0 && indexOfSet < flashcardSet.count {
            if let currAnswer = flashcardSet[indexOfSet].getCurrentAnswer() {
                return currAnswer
            } else {
                return "You're done studying!"
            }
        }
        return "Index out of range"
    }
    
    // find the next card within the current set, which set is found via index
    func nextCardInSet(indexOfSet: Int) {
        print("card No.: \(flashcardSet[indexOfSet].cardNumber + 1) ......... index: \(flashcardSet[indexOfSet].cardNumber)")
        
        // Only move to the next card if there is a next one
        if flashcardSet[indexOfSet].cardNumber < flashcardSet[indexOfSet].flashcards.count {
            flashcardSet[indexOfSet].nextCard()
        } else {
            print("Already reached the end of the cards.")
        }

    }
    
    // assign card as mastered within the current set, which set is found via index
    func masteredCard (indexOfSet: Int){
        let currCard = flashcardSet[indexOfSet].cardNumber
        flashcardSet[indexOfSet].markCardAsMastered(at: currCard)
    }
    
    // assign card as UNMASTERED within the current set, which set is found via index
    func unmasteredCard (indexOfSet: Int){
        let currCard = flashcardSet[indexOfSet].cardNumber
        flashcardSet[indexOfSet].markCardAsUnmastered(at: currCard)
    }
    
    // assign mastered card back to  unmastered within the current set, which set is found via index
    func unmarkMasteredCard (indexOfSet: Int){
        let currCard = flashcardSet[indexOfSet].cardNumber
        flashcardSet[indexOfSet].unmarkMasteredCard(at: currCard)
    }
    
    // adding a flashcard set
    func addFlashcardSet(_ newFlashcardSet: FlashCardSet){
        flashcardSet.append(newFlashcardSet)
        print("Flashcard Sets after addition: \(flashcardSet)")
    }

    // remove flashcard set by index
    func removeFlashcardSetByIndex(index: Int){
        // check if the index is valid
        if index >= 0 && index < flashcardSet.count{
            flashcardSet.remove(at: index);
            print("Flashcard Set removed at: \(index)")
        }
    }
    
    // progress bar of mastery for a specifc flashcard set
    func progressForMastery(for setIndex: Int) -> Float{
        return flashcardSet[setIndex].getProgressOfMastery()
    }
    
    // progress bar of how mnay cards the user has currently studied in set
    func progessOfCardsStudied(for setIndex: Int) -> Float{
        return flashcardSet[setIndex].getProgressOfCardsStudied()
    }
    
    
    // shuffle the cards within the current set, which set is found via index
    func suffleCardsInSet(indexOfSet: Int){
        flashcardSet[indexOfSet].shuffleCards()
        
        // print the questions of each card to see if they are shuffled
        for flashcard in flashcardSet[indexOfSet].flashcards {
            print(flashcard.question)
        }
    }
    
    //
    func resetStudyProgress(for index: Int) {
        flashcardSet[index].cardNumber = 0
        
    }
    
    // load flashcard set
    
    
}
