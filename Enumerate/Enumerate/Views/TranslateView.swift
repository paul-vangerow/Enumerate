//
//  TranslateView.swift
//  Enumerate
//
//  Created by Paul on 02/07/2023.
//

import SwiftUI

struct TranslateView: View {
    var milestone: Milestone
    var current_card: CardHolder
    var isEditing: FocusState<Bool>.Binding?
    
    @State var guess: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 340, height: 500)
            if current_card.complete == true {
                CompletionBanner(height: 150, width: 150)
                    .offset(x: 100, y: -180)
            }
            VStack {
                Spacer()
                    .frame(height: 220)
                if current_card.orientation == true {
                    HeadingText(text: current_card.card.pair.first, size: 30, color: false)
                } else {
                    HeadingText(text: current_card.card.pair.second, size: 30, color: false)
                }
                Spacer()
                ZStack {
                    HeadingText(text: "_____________________________", size: 20, color: false)
                        .padding(.top)
                    TextField("", text: $guess)
                        .focused(isEditing ?? FocusState<Bool>().projectedValue )
                        .multilineTextAlignment(.center)
                        .font(.system(size: 25, design: .rounded))
                        .foregroundColor(Color("WhiteBGText"))
                        .frame(width: 300, height: 200)
                }
                Spacer()
                Button(action: {
                    if guess.lowercased() == (current_card.orientation == true ? current_card.card.pair.second.lowercased() : current_card.card.pair.first.lowercased()) {
                        milestone.completeCard(cardID: current_card.id )
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("WhiteBGText"))
                            .frame(width: 150, height: 50)
                        HeadingText(text: "Check", size: 25, color: true)
                    }
                }
                Spacer()
                    .frame(height: 200)
            }
        }
    }
}

struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background")
            TranslateView(milestone: Group.PreSpanish.milestones[0], current_card: Group.PreSpanish.milestones[0].cards[0])
        }
    }
}
