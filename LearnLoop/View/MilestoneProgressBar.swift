//
//  MilestoneProgressBar.swift
//  LearnLoop
//
//  Created by Klarissa Navarro on 5/1/25.
//

import SwiftUI

struct MilestoneProgressBar: View {
    var progress: Double // from 0.0 to 1.0
    var milestones: [Double] // milestone points from 0.0 to 1.0

    var body: some View {
        VStack(){
            
            GeometryReader { geo in
                let width = geo.size.width

                ZStack() {
                    // bacground (uncolored progress bar)
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.white.opacity(0.5)))
                        .frame(height: 40)
                        .cornerRadius(5)
                                        
                    // Progress bar
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                        .frame(height: 40)
                        .cornerRadius(5)
    
                    
                    // Milestone markers and labels
                    ZStack(alignment: .leading) {
                        ForEach(milestones, id: \.self) { milestone in
                            VStack(spacing: 2) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 15, height: 40)
                                Text("\(Int(milestone * 100))%")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    
                            }
                            .frame(width: 50, alignment: .center)
                            .position(x: width * CGFloat(milestone), y: 22)
                        }
                    }
                    .frame(height: 30)

                }
            }
           // .frame(height: 60) // total height including ticks and labels
            .padding(.horizontal)
        }
    }
}


