//
//  Flashcard.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/31/25.
//
import Foundation

// NOTE:
// Equatable will be used to compare the content of the cards easier
// ID will be useful when editing the flashcard set: 1) keep perserve the isMastered state and 2) remove a card from masteredCardsArray if it's deleted
struct Flashcard: Identifiable, Equatable, Codable  {
    let id: UUID
    var question: String
    var answer: String
    var isMastered: Bool    // the person mastered the flahcard or not
    
    init(id: UUID = UUID(), q: String, a: String, isMastered: Bool = false) {
        self.id = id
        self.question = q
        self.answer = a
        self.isMastered = isMastered
    }
}
