//
//  CardView.swift
//  Enumerate
//
//  Created by Paul on 02/07/2023.
//

import SwiftUI

struct CardView: View {
    var milestone: Milestone
    var currentCard: CardHolder
    
    var isEditing: FocusState<Bool>.Binding?
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                    .frame(width: 30)
                if currentCard.card.type == .FlashCard {
                    FlashCardView(milestone: milestone, current_card: currentCard)
                } else {
                    TranslateView(milestone: milestone, current_card: currentCard, isEditing: isEditing)
                }
                Spacer()
                    .frame(width: 30)
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CardView(milestone: Group.PreSpanish.milestones[0], currentCard: Group.PreSpanish.milestones[0].cards[0])
        }
    }
}
