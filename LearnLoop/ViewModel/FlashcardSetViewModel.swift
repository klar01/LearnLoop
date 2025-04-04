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
            Flashcard(q: "some question 1", a: "some answer for question 1", isMastered: true),
            Flashcard(q: "some question 2nd", a: "some answer for question 2nd"),
            Flashcard(q: "some question 2nd", a: "some answer for question 2nd"),
            Flashcard(q: "some question 2nd", a: "some answer for question 2nd"),
            Flashcard(q: "some question 1", a: "some answer for question 1", isMastered: true),
            Flashcard(q: "some question 2nd", a: "some answer for question 2nd", isMastered: true),
            Flashcard(q: "some question 2nd", a: "some answer for question 2nd", isMastered: true),
            Flashcard(q: "some question 2nd", a: "some answer for question 2nd"),
        ]),
        FlashCardSet(title: "ANOTHER ONE", flashcards: [
            Flashcard(q: "some question 1", a: "some answer for question 1"),
            Flashcard(q: "some question 2nd", a: "some answer for question 2nd")
        ])
    ]
    
    // adding a flashcard set
    func addFlashcardSet(_ newFlashcardSet: FlashCardSet){
        flashcardSet.append(newFlashcardSet)
        print("Flashcard Sets after addition: \(flashcardSet)")
    }
    
    // remove flashcard set
    func removeFlashcardSet(title: String){
        if let index = flashcardSet.firstIndex(where: { $0.title == title }){
            flashcardSet.remove(at: index);
            print("Flashcard Set removed: \(title)")
        }
        
    }
    
    // progress bar of mastery for a specifc flashcard set
    func progress(for setIndex: Int) -> Float{
        return flashcardSet[setIndex].getProgress()
    }
    
    // shuffle the cards
    
    // load flashcard set
}
