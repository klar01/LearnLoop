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
    
    // computed property
    var unMastered: Int{
        return flashcards.filter({ !$0.isMastered }).count // NOTE: '$0' is shorthand syntax to refer to the current item
    }
    
    init(title: String, flashcards: [Flashcard]) {
        self.title = title
        self.flashcards = flashcards
    }
    
    
    // show the how much of the cards the user has mastered out of all the cards
    func getProgress() -> Float{
        let masteredCount = flashcards.filter { $0.isMastered }.count
        return Float(masteredCount) / Float(flashcards.count)
    }
    
    // mark the card as mastered if it has a vaild index
    mutating func markCardAsMastered (at index: Int){
        if(index >= 0 && index < flashcards.count){
            flashcards[index].isMastered = true
        }
    }
    
    // unmark an existing mastered card if it has a valid index
    mutating func unmarkMasteredCard(at index: Int){
        if(index >= 0 && index < flashcards.count){
            flashcards[index].isMastered = false
        }
    }
    
}
