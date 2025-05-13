//
//  FlashcardSetValidator.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 5/11/25.
//

import Foundation

struct FlashcardValidator {
    static func validateFlashcards(title: String, flashcards: [Flashcard]) -> String? {
        // check if there is a missing title
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "The title cannot be empty."
        }
        
        // check if set has less than 2 cards
        if flashcards.count < 2 {
            return "Must have at least 2 flashcards in your set."
        }
        
        //check if flashcard has a missing answer OR question
        for card in flashcards {
            if card.question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
               card.answer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "All questions and answers must be filled in."
            }
        }
        
        return nil // Valid input
    }
}
