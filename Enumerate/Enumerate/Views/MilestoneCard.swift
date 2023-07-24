//
//  MilestoneCard.swift
//  Enumerate
//
//  Created by Paul on 26/06/2023.
//

import SwiftUI

struct MilestoneCard: View {
    @ObservedObject var mileStone: Milestone
    
    var progress: CGFloat {
        CGFloat(mileStone.localCardCompletion) / CGFloat(mileStone.cardSizeValue)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("Border"),lineWidth: 3)
                .background {
                    if (mileStone.milestoneState == .DONE) {
                        Rectangle()
                            .fill(Color("Progress"))
                    } else if ( mileStone.milestoneState == .PROGRESS ) {
                        ProgressBar(completion: progress , width: 320, height: 50, roundedness: 20)
                    } else {
                        Rectangle()
                            .fill(Color("NotStarted"))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 320, height: 50)
            Text( String(mileStone.id * 10) )
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
    }
}

struct MilestoneCard_Previews: PreviewProvider {
    static var previews: some View {
        MilestoneCard( mileStone: Group.PreSpanish.milestones[0])
    }
}
