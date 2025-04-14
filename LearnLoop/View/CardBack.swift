//
//  CardBack.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 4/4/25.
//

import SwiftUI

struct CardBack : View {
    @Binding var degree : Double
    var answerText: String
    var color: Color 

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)  // Fill with background color
                .frame(minHeight: 250)
                .frame(maxWidth: UIScreen.main.bounds.width - 40)
            
            Text(answerText).padding()
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))        
    }
}

