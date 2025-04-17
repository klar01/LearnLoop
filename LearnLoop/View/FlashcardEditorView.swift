//
//  FlashcardEditorView.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/14/25.
//

import SwiftUI

struct FlashcardEditorView: View {
    @Binding var title: String
    @Binding var flashcards: [Flashcard]

    var body: some View {
        VStack(spacing: 20) {
            // Title input
            VStack {
                Text("Title")
                    .foregroundColor(.white)
                
                HStack {
                    TextField("", text: $title, prompt: Text("Name Set").foregroundColor(.white))
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        .padding(.trailing, 20)
                }
                .padding()
                .cornerRadius(10)
                .background(Color(red: 58/255, green: 58/255, blue: 60/255))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
            }

            // List of flashcards
            ScrollViewReader { proxy in
                // created list instead of ScrollView b/c it will be easier to remove the card if you swipe
                List {
                    ForEach(flashcards) { card in
                        if let index = flashcards.firstIndex(where: { $0.id == card.id }) {
                            Section {
                                VStack(alignment: .leading, spacing: 10) {
                                    // Question
                                    VStack(alignment: .leading) {
                                        Text("Question")
                                            .foregroundColor(.gray)
                                            .font(.body)
                                        TextEditor(text: $flashcards[index].question)
                                            .frame(minHeight: 30)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .fixedSize(horizontal: false, vertical: true)  // Allow vertical expansion based on content
                                    }
                                    
                                    // border between question and answer
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray)
                                    
                                    // Answer
                                    VStack(alignment: .leading) {
                                        Text("Answer")
                                            .foregroundColor(.gray)
                                            .font(.body)
                                        TextEditor(text: $flashcards[index].answer)
                                            .frame(minHeight: 30)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .fixedSize(horizontal: false, vertical: true)  // Allow vertical expansion based on content
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.vertical, 10) // adds spacing between cards
                                
                                // to remove card
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        flashcards.remove(at: index)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                
                                // Divider between cards
                                Rectangle()
                                    .frame(height: 3)
                                    .frame(width: 100)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                            }
                            .listRowInsets(EdgeInsets()) //remove default padding (ideal width of card)
                            .listRowBackground(Color.clear) // clear backgroundt to show the spacing between cards
                            .id(index) // Assign an id for scroll action
                        }
                        
                    }
                        
                    // Add Card Button
                    Section {
                        Button(action: {
                            flashcards.append(Flashcard(q: "", a: ""))
                            
                            // Scroll to the newly added card
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {  // time to allow for the new card to be added
                                // makes adding the card loook more naturally than appear abruptly
                                withAnimation {
                                    proxy.scrollTo("BottomSpacer", anchor: .bottom) // Scroll to "BottomSpacer" element so the card and "add" button are in within view
                                }
                            }
                        }) {
                            HStack {
                                Text("+ Add Flashcard")
                            }
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center) // center the text/icon
                            .padding(.vertical, 10) // creates spacings between cards
                        }
                        .listRowBackground(Color.clear) // transparent background for the list row
                        .listRowInsets(EdgeInsets())    // removes unwanted padding
                        
                        Color.clear
                            .frame(height: 1)
                            .id("BottomSpacer").listRowBackground(Color.clear)
                    }
                    
                    
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}
