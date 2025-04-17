//
//  Untitled.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/31/25.
//

import Foundation

struct FlashCardSet{
    var title: String
    var flashcards: [Flashcard]
    var cardNumber = 0
    
    // computed property
    var unMastered: Int{
        return flashcards.filter({ !$0.isMastered }).count // NOTE: '$0' is shorthand syntax to refer to the current item
    }
    
    // computed property
    var masteredCards: Int{
        return flashcards.filter({ $0.isMastered }).count // NOTE: '$0' is shorthand syntax to refer to the current item
    }
    
    // NOTE: Replaced manual arrays w/computed property the  mastered/unmastered away to ensure the lists are accurate and in sync with the main flashcards array
    var masteredCardsArray: [Flashcard] {
        flashcards.filter { $0.isMastered }
    }

    var unmasteredCardsArray: [Flashcard] {
        flashcards.filter { !$0.isMastered }
    }
    
    // total cards in flashcard set
    var total: Int {
        return flashcards.count
    }
    
    init(title: String, flashcards: [Flashcard]) {
        self.title = title
        self.flashcards = flashcards
    }
    
    func getCurrentQuestion() -> String? {
        guard cardNumber < flashcards.count else { return nil }
        return flashcards[cardNumber].question
    }
    
    func getCurrentAnswer() -> String? {
        guard cardNumber < flashcards.count else { return nil}
        return flashcards[cardNumber].answer
    }
    
    mutating func nextCard(){
        if(cardNumber < flashcards.count){
            cardNumber = cardNumber + 1
        }
    }
    
    mutating func incrementNumOfSwipes(){
        cardNumber = cardNumber + 1
    }
    
    // show the how much of the cards the user has mastered out of all the cards
    func getProgressOfMastery() -> Float{
        let masteredCount = flashcards.filter { $0.isMastered }.count
        return Float(masteredCount) / Float(flashcards.count)
    }
    
    // progress bar of how mnay cards the user has currently studied in set
    func getProgressOfCardsStudied() -> Float{
        return Float(cardNumber) / Float(flashcards.count)
    }
    
    // mark the card as mastered if it has a vaild index
    mutating func markCardAsMastered (at index: Int){
        if index >= 0 && index < flashcards.count {
            flashcards[index].isMastered = true
        }
    }
    
    // mark the card as unmastered if it has a vaild index
    mutating func markCardAsUnmastered (at index: Int){
        if index >= 0 && index < flashcards.count {
            flashcards[index].isMastered = false
        }
    }
    
    // unmark an existing mastered card if it has a valid index
    mutating func unmarkMasteredCard(at index: Int){
        if(index >= 0 && index < flashcards.count){
            flashcards[index].isMastered = false
        }
    }
    
    // shuffle the cards in the set
    mutating func shuffleCards(){
        flashcards = flashcards.shuffled() // randomly reorder the elements of an array
    }
    
    
}
