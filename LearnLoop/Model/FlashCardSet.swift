//
//  Untitled.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/31/25.
// NOTE: Replaced manual arrays w/computed property the  mastered/unmastered away to ensure the lists are accurate and in sync with the main flashcards array
// NOTE: '$0' is shorthand syntax to refer to the current item

import Foundation

struct FlashCardSet: Identifiable{
    enum StudyMode {
        case fullSet
        case unmasteredOnly
    }
    
    let id: UUID
    var title: String
    var flashcards: [Flashcard] // full set (mastered and unmastered)
    var cardNumber = 0
    
    // MARK: - New for session
    private(set) var currentSessionCards: [Flashcard] = []
    private(set) var currentStudyMode: StudyMode = .fullSet
    
    init(id: UUID = UUID(), title: String, flashcards: [Flashcard]) {
        self.id = id
        self.title = title
        self.flashcards = flashcards
    }
    
   // array of only mastered cards
    var masteredCardsArray: [Flashcard] {
        flashcards.filter { $0.isMastered }
    }
    // array of only mastered cards
    var unmasteredCardsArray: [Flashcard] {
        flashcards.filter { !$0.isMastered }
    }
    
    // total unmastered cards
    var unMastered: Int{
        return flashcards.filter({ !$0.isMastered }).count
    }
    
    // total mastered cards
    var masteredCards: Int{
        return flashcards.filter({ $0.isMastered }).count
    }
    
    // total cards in flashcard set
    var total: Int { return flashcards.count}
    
    
    // show the how much of the cards the user has mastered out of all the cards
    func getProgressOfOverallMastery() -> Float{
        let masteredCount = flashcards.filter { $0.isMastered }.count
        return Float(masteredCount) / Float(flashcards.count)
    }
    
    // New functions to test FOR SESSION MODE (to replace the other functions)
    //gets the cards assoicated w/session mode type
    // Start a study session
    mutating func startStudySession(mode: StudyMode) {
        cardNumber = 0  // always restart the session
        currentStudyMode = mode
        switch mode {
        case .fullSet:
            currentSessionCards = flashcards
        case .unmasteredOnly:
            currentSessionCards = flashcards.filter { !$0.isMastered }
        }
    }
    
    // current card in session mode
    func getCurrentCard() -> Flashcard? {
        guard cardNumber < currentSessionCards.count else { return nil }
        return currentSessionCards[cardNumber]
    }
    
    // next card in session mode
    mutating func incrementCard() {
        if(cardNumber < currentSessionCards.count){
            cardNumber += 1
        }
    }
 
    // progress bar of how many cards the user has currently studied in setsession mode
    func getProgressOfCardsStudiedSession() -> Float {
        guard !currentSessionCards.isEmpty else { return 0 }
        return Float(cardNumber) / Float(currentSessionCards.count)
    }
    
    // shuffle cards
    mutating func shuffleSessionCards() {
        currentSessionCards.shuffle()
        cardNumber = 0
    }
    
    // master card
        // if fullSet, any unmastered cards should later be seen in the unmasteredOnly session later
    // unmastered card
        // if unmasteredOnly, any cards marked as mastered during the session will be appened to the fullSet
        
        // NOTE: while going throught the set, the set shouldn't dynmically shrink when card is marked as mastered
        // for e.g. there are 7 cards, i marked the 2nd card as 'mastered', which will cause theres to be 6 cards instead of 7, and so forth, which will cause index out of arrange error. MUST AVOID THIS!!
    mutating func markCurrentCardAsMastered() {
        guard cardNumber < currentSessionCards.count else { return }
        let currentCardId = currentSessionCards[cardNumber].id
        if let index = flashcards.firstIndex(where: { $0.id == currentCardId }) {
            flashcards[index].isMastered = true
        }
        // Note: do not remove from currentSessionCards here to avoid shrinking the array mid-session
    }
    
    mutating func markCurrentCardAsUnmastered() {
        guard cardNumber < currentSessionCards.count else { return }
        let currentCardId = currentSessionCards[cardNumber].id
        if let index = flashcards.firstIndex(where: { $0.id == currentCardId }) {
            flashcards[index].isMastered = false
        }
        // Do NOT modify currentSessionCards
    }

}
