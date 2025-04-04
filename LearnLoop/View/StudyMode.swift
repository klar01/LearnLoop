//
//  Untitled.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 3/30/25.
//

// User begins studying the entire flashcard set
// card animation
// swiping gestures
import SwiftUI

struct StudyMode: View{
    @ObservedObject var viewModel: FlashcardSetViewModel
    var flashCardSet: FlashCardSet
    
    var body: some View{
        ZStack{
            // Background Color
            Color(red: 28/255, green: 28/255, blue: 30/255)
                .edgesIgnoringSafeArea(.all) // Color the entire screen
            
            VStack{
                VStack{
                    Text("title of set").foregroundColor(.white)
                }
                
                Spacer()

                //Front Card
                VStack{
                    Text("sdhb cxhjsd fd bjh b cxhjsd fd bjhsbd ssdh bd hb cxhjsd fd bjhsbd ssdhssdhs hb cxhjsd fd bjhsbd ssdh hb cxhjsd fd bjhsbd ss b cxhjsd fd bjhsbd ssdh bd hb cxhjsd fd bjhsbd ssdhssdhs hb cxhjsd")
                        .frame(minHeight: 250)
                        .padding()
                        .background(Color.white)
                        .frame(maxWidth: UIScreen.main.bounds.width - 40)
                        .fixedSize(horizontal: false, vertical: true)  // Allow vertical expansion based on content
                    
                    
                }
                .background(.white)
                .cornerRadius(10)
                .frame(maxWidth: UIScreen.main.bounds.width - 40)
            
                Spacer()

                
                Button("Finish Studying"){
                    //some action
                    
                }
                .padding()
                .foregroundColor(.black)
                .fontWeight(.bold)
                .frame(maxWidth: 200)
                .cornerRadius(10)
                .background(Color(red: 218/255, green: 143/255, blue: 255))
                
                
            }.padding()
            
        }
    }
}

#Preview {
    // Create a sample FlashcardSet to pass to StudyMode
    let viewModel = FlashcardSetViewModel()
    let sampleSet = FlashCardSet(title: "Sample Set", flashcards: [
        Flashcard(q: "What is Swift?", a: "A programming language"),
        Flashcard(q: "What is 2 + 2?", a: "4")
    ])
    
    // Return the StudyMode view with both viewModel and sampleSet
    StudyMode(viewModel: viewModel, flashCardSet: sampleSet)
}
