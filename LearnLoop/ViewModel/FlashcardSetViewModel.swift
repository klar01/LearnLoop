//
//  FlashcardSetViewModel.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/2/25.
//

import Foundation

// handle the data logic for the flashcard set
class FlashcardSetViewModel: ObservableObject {
    @Published var flashcardSet: [FlashCardSet] = []
    @Published var userManager = UserManager()
    
    init() {
        // Load flashcards for the current user when initialized
        loadFlashcards()
    }
    
    // Load flashcards from UserManager
    func loadFlashcards() {
        flashcardSet = userManager.loadFlashcards()
        print("Loaded \(flashcardSet.count) flashcard sets from storage")
    }
    
    // Save flashcards using UserManager
    func saveFlashcards() {
        userManager.saveFlashcards(flashcardSet)
        print("Saved \(flashcardSet.count) flashcard sets to storage")
    }
    
    // Load flashcards when user logs in
    func loadFlashcardsForUser() {
        flashcardSet = userManager.loadFlashcards()
        print("Loaded flashcards for user: \(userManager.currentUserEmail)")
    }
    
    // Clear flashcards when user logs out
    func clearFlashcards() {
        flashcardSet = []
        print("Cleared flashcards from memory")
    }
    
    //current card's question for a specifc flashcard set
    func currentQuestion(indexOfSet: Int) -> String {
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else {
            return "Index out of range"
        }
        
        if let currQuestion = flashcardSet[indexOfSet].getCurrentCard()?.question {
            return currQuestion
        }
        return "Question--You're done studying!"
    }
    
    // current card's answer for a specifc flashcard set
    func currentAnswer(indexOfSet: Int) -> String {
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else {
            return "Index out of range"
        }
        
        if let currAnswer = flashcardSet[indexOfSet].getCurrentCard()?.answer {
            return currAnswer
        }
        return "ANSWER-- You're done studying!"
    }
    
    // get the next card within the current set, which set is found via index
    func nextCardInSet(indexOfSet: Int) {
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return }
        
        if flashcardSet[indexOfSet].cardNumber < flashcardSet[indexOfSet].currentSessionCards.count {
            flashcardSet[indexOfSet].incrementCard()
        }
        saveFlashcards() // Save after updating card progress
    }
    
    // assign card as mastered within the current set, which set is found via index
    func masteredCard (indexOfSet: Int){
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return }
        
        flashcardSet[indexOfSet].markCurrentCardAsMastered()
        saveFlashcards() // Save after marking card as mastered
    }
    
    // assign card as UNMASTERED within the current set, which set is found via index
    func unmasteredCard (indexOfSet: Int){
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return }
        
        flashcardSet[indexOfSet].markCurrentCardAsUnmastered()
        saveFlashcards() // Save after marking card as unmastered
    }
    
    // adding a flashcard set
    func addFlashcardSet(_ newFlashcardSet: FlashCardSet){
        flashcardSet.append(newFlashcardSet)
        saveFlashcards() // Save after adding new set
        print("Flashcard Sets after addition: \(flashcardSet)")
    }

    // remove flashcard set by index
    func removeFlashcardSetByIndex(index: Int){
        guard index >= 0 && index < flashcardSet.count else {
            print("Index \(index) is out of bounds. Count: \(flashcardSet.count)")
            return
        }
        
        print("Flashcard Set removed at: \(index)")
        flashcardSet.remove(at: index)
        saveFlashcards() // Save after removing set
        print("Flashcard Set count AFTER removal: \(flashcardSet.count)")
    }
    
    // progress bar of mastery for a specifc flashcard set
    func progressForOverallMastery(for setIndex: Int) -> Float{
        guard setIndex >= 0 && setIndex < flashcardSet.count else { return 0.0 }
        return flashcardSet[setIndex].getProgressOfOverallMastery()
    }
    
    //progress bar of how many cards the user has currently studied in set
    func progessOfCardsStudied(for setIndex: Int) -> Float{
        guard setIndex >= 0 && setIndex < flashcardSet.count else { return 0.0 }
        return flashcardSet[setIndex].getProgressOfCardsStudiedSession()
    }
    
    //shuffle the cards within the current set, which set is found via index
    func suffleCardsInSet(indexOfSet: Int){
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return }
        
        flashcardSet[indexOfSet].shuffleSessionCards()
        
        for flashcard in flashcardSet[indexOfSet].currentSessionCards {
            print(flashcard.question)
        }
    }
    
    func getMasteredSessionCards (indexOfSet: Int) -> [Flashcard]{
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return [] }
        
        let set = flashcardSet[indexOfSet]
        let sessionCards = set.currentSessionCards

        return sessionCards.filter { set.isMastered(id: $0.id) == true }
    }
    
    func getUnmasteredSessionCards (indexOfSet: Int) -> [Flashcard]{
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return [] }
        
        let set = flashcardSet[indexOfSet]
        let sessionCards = set.currentSessionCards

        return sessionCards.filter { set.isMastered(id: $0.id) == false }
    }

    //EDITED-- filter out the cards by their status
    func getStudiedCards(indexOfSet: Int, status: String) -> [Flashcard] {
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return [] }
        
        switch (status) {
        // mode: unmastered cards
        case ("Learning"):
            return getUnmasteredSessionCards(indexOfSet: indexOfSet)
        // mode: mastered cards
        case ("Mastered"):
            return getMasteredSessionCards(indexOfSet: indexOfSet)
    
        default:
            return flashcardSet[indexOfSet].currentSessionCards
        }
    }

    // ucser can edit the flashcard set -- add/remove/edit cards and edit title
    func updateFlashcardSet(at index: Int, newTitle: String, newFlashcards: [Flashcard]) {
        guard index >= 0 && index < flashcardSet.count else { return }
        
        var updatedFlashcards: [Flashcard] = []
        let oldFlashcards = flashcardSet[index].flashcards // orginal set
        
        // loop through each card in the edited set
        for newCard in newFlashcards {
            
            // check if the new card has exist in the orginal set
            if let matchingOldCard = oldFlashcards.first(where: { $0.id == newCard.id }) {
                // check if content was completely changed (i.e. user rewrote question AND answer instead of deleting card)
                if matchingOldCard.question != newCard.question && matchingOldCard.answer != newCard.answer {
                    // treat as a "new card" – reset mastered status
                    var rewrittenCard = newCard
                    rewrittenCard.isMastered = false
                    updatedFlashcards.append(rewrittenCard)
                                    
                    print(" Completely rewritten card (reset mastery) --> Q: \(rewrittenCard.question) && A: \(rewrittenCard.answer) && (isMastered: \(rewrittenCard.isMastered))")
                    
                } else {
                    // retain mastery state
                    var preservedCard = newCard
                    preservedCard.isMastered = matchingOldCard.isMastered
                    updatedFlashcards.append(preservedCard)
                    print("Preserved card --> Q: \(preservedCard.question) && A: \(preservedCard.answer) && (isMastered: \(preservedCard.isMastered))")
                }
               
            } else {
                // New card - add it
                updatedFlashcards.append(newCard)
                print("+ New card --> Q: \(newCard.question) && A: \(newCard.answer) && (isMastered: \(newCard.isMastered))")
            }
        }
        
        // update the (original) flashcard set
        flashcardSet[index].title = newTitle
        flashcardSet[index].flashcards = updatedFlashcards
        
        // rebuild index map
        flashcardSet[index].buildIndexMap()
        
        // rebuild session using the current mode
        let currentMode = flashcardSet[index].currentStudyMode
        flashcardSet[index].startStudySession(mode: currentMode)
        
        saveFlashcards() // Save after updating flashcard set
    }
    
    // user can choose to study the full set or unmastered cards
    func setModeSession (indexOfSet: Int, mode: FlashCardSet.StudyMode){
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return }
        flashcardSet[indexOfSet].startStudySession(mode: mode)
    }
    
    // shows the progress of the session (full set/ unmastered set)
    func getSessionProgress (indexOfSet: Int, mode: FlashCardSet.StudyMode) -> Float{
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return 0.0 }
        return flashcardSet[indexOfSet].getProgressForSession(mode: mode)
    }

    func getTotalSessionCards (indexOfSet: Int) -> Int{
        guard indexOfSet >= 0 && indexOfSet < flashcardSet.count else { return 0 }
        return flashcardSet[indexOfSet].currentSessionCards.count
    }
    
    func getTotalMasteredSessionCards(indexOfSet: Int) -> Int {
        return getMasteredSessionCards(indexOfSet: indexOfSet).count
    }
    
    func getTotalUnmasteredSessionCards(indexOfSet: Int) -> Int{
        return getUnmasteredSessionCards(indexOfSet: indexOfSet).count
    }
}
