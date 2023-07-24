//
//  FlashCardView.swift
//  Enumerate
//
//  Created by Paul on 02/07/2023.
//

import SwiftUI

struct FlashCardView: View {
    var milestone: Milestone
    var current_card: CardHolder
    
    @State var frontAngle: CGFloat = 0
    @State var backAngle: CGFloat = 89.999
    @State var isFlipped = true
    
    var body: some View {
        VStack {
            ZStack {
                CardFront(degree: $frontAngle, milestone: milestone, card: current_card)
                CardBack(degree: $backAngle, milestone: milestone, card: current_card)
            }
            .onTapGesture {
                isFlipped = !isFlipped
                if isFlipped {
                    withAnimation(.linear(duration: 0.3)) {
                        backAngle = 89.999
                    }
                    withAnimation(.linear(duration: 0.3).delay(0.3)){
                        frontAngle = 0
                    }
                    milestone.completeCard(cardID: current_card.id)
                } else {
                    withAnimation(.linear(duration: 0.3)) {
                        frontAngle = -89.999
                    }
                    withAnimation(.linear(duration: 0.3).delay(0.3)){
                        backAngle = 0
                    }
                }
            }
        }
    }
}

struct CardFront: View {
    @Binding var degree: CGFloat
    var milestone: Milestone
    var card: CardHolder
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 340, height: 500)
            if card.complete == true {
                CompletionBanner(height: 150, width: 150)
                    .offset(x: 100, y: -180)
            }
            HeadingText(text: card.card.pair.first, size: 30, color: false)
            
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct CardBack: View {
    @Binding var degree: CGFloat
    var milestone: Milestone
    var card: CardHolder
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 340, height: 500)
            if card.complete == true {
                CompletionBanner(height: 150, width: 150)
                    .offset(x: 100, y: -180)
            }
            HeadingText(text: card.card.pair.second, size: 30, color: false)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            FlashCardView(milestone: Group.PreSpanish.milestones[0], current_card: Group.PreSpanish.milestones[0].cards[0])
        }
    }
}
