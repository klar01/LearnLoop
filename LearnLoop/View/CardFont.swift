//
//  CardFont.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/4/25.
//

// display the font of the card (aka the question)
import SwiftUI

struct CardFront : View {
    @Binding var degree : Double
    var questionText: String
    var color: Color 

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(minHeight: 250)
                .frame(maxWidth: UIScreen.main.bounds.width - 40)
            
            Text(questionText).padding()
              
        }
        .fixedSize(horizontal: false, vertical: true)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
       
    }
}
