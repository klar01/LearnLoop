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
            Flashcard(q: "What is Swift?", a: "A programming language", isMastered: true),
            Flashcard(q: "What is 2 + 2?", a: "4", isMastered: true),
            Flashcard(q: "color of sky?", a: "blue", isMastered: true),
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
    
    //current card's question for a specifc flashcard set
    func currentQuestion(indexOfSet: Int) -> String {
        if indexOfSet >= 0 && indexOfSet < flashcardSet.count {
            if let currQuestion = flashcardSet[indexOfSet].getCurrentCard()?.question {
                return currQuestion
            }
            return "Question--You're done studying!"
            
        }
         return "Index out of range"
    }
    
    // current card's answer for a specifc flashcard set
    func currentAnswer(indexOfSet: Int) -> String {
        if indexOfSet >= 0 && indexOfSet < flashcardSet.count {
            if let currAnswer = flashcardSet[indexOfSet].getCurrentCard()?.answer {
                return currAnswer
            }
            return "ANSWER-- You're done studying!"
            
        }
        return "Index out of range"
    }
    
    // get the next card within the current set, which set is found via index
    func nextCardInSet(indexOfSet: Int) {
        if flashcardSet[indexOfSet].cardNumber < flashcardSet[indexOfSet].currentSessionCards.count {
            flashcardSet[indexOfSet].incrementCard()
        }
    }
    
    // assign card as mastered within the current set, which set is found via index
    func masteredCard (indexOfSet: Int){
        flashcardSet[indexOfSet].markCurrentCardAsMastered()
    }
    
    // assign card as UNMASTERED within the current set, which set is found via index
    func unmasteredCard (indexOfSet: Int){
        flashcardSet[indexOfSet].markCurrentCardAsUnmastered()
    }
    
    // adding a flashcard set
    func addFlashcardSet(_ newFlashcardSet: FlashCardSet){
        flashcardSet.append(newFlashcardSet)
        print("Flashcard Sets after addition: \(flashcardSet)")
    }

    // remove flashcard set by index
    func removeFlashcardSetByIndex(index: Int){
        if index >= 0 && index < flashcardSet.count {
                print("Flashcard Set removed at: \(index)")
                flashcardSet.remove(at: index)
                print("Flashcard Set count AFTER removal: \(flashcardSet.count)")
            } else {
                print("Index \(index) is out of bounds. Count: \(flashcardSet.count)")
            }
    }
    
    // progress bar of mastery for a specifc flashcard set
    func progressForOverallMastery(for setIndex: Int) -> Float{
        return flashcardSet[setIndex].getProgressOfOverallMastery()
    }
    
    //progress bar of how many cards the user has currently studied in set
    func progessOfCardsStudied(for setIndex: Int) -> Float{
        return flashcardSet[setIndex].getProgressOfCardsStudiedSession()
    }
    
    //shuffle the cards within the current set, which set is found via index
    func suffleCardsInSet(indexOfSet: Int){
        flashcardSet[indexOfSet].shuffleSessionCards()
        
        for flashcard in flashcardSet[indexOfSet].currentSessionCards {
            print(flashcard.question)
        }
        
    }
    
    func getMasteredSessionCards (indexOfSet: Int) -> [Flashcard]{
        let set = flashcardSet[indexOfSet]
        let sessionCards = set.currentSessionCards

        return sessionCards.filter { set.isMastered(id: $0.id) == true }
    }
    
    func getUnmasteredSessionCards (indexOfSet: Int) -> [Flashcard]{
        let set = flashcardSet[indexOfSet]
        let sessionCards = set.currentSessionCards

        return sessionCards.filter { set.isMastered(id: $0.id) == false }
    }

    //EDITED-- filter out the cards by their status
    func getStudiedCards(indexOfSet: Int, status: String) -> [Flashcard] {
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
    }
    
    // user can choose to study the full set or unmastered cards
    func setModeSession (indexOfSet: Int, mode: FlashCardSet.StudyMode){
        flashcardSet[indexOfSet].startStudySession(mode: mode)
    }
    
    // shows the progress of the session (full set/ unmastered set)
    func getSessionProgress (indexOfSet: Int, mode: FlashCardSet.StudyMode) -> Float{
        return flashcardSet[indexOfSet].getProgressForSession(mode: mode)
    }

    func getTotalSessionCards (indexOfSet: Int) -> Int{
        return flashcardSet[indexOfSet].currentSessionCards.count
    }
    
    func getTotalMasteredSessionCards(indexOfSet: Int) -> Int {
        return getMasteredSessionCards(indexOfSet: indexOfSet).count
    }
    
    func getTotalUnmasteredSessionCards(indexOfSet: Int) -> Int{
        return getUnmasteredSessionCards(indexOfSet: indexOfSet).count
    }
}
