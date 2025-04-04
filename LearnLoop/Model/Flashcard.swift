//
//  Flashcard.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/31/25.
//
import Foundation

struct Flashcard {
    var question: String
    var answer: String
    var isMastered: Bool    // the person mastered the flahcard or not
    
    //
    init(q: String, a: String, isMastered: Bool = false) {
        self.question = q
        self.answer = a
        self.isMastered = isMastered
    }
}
