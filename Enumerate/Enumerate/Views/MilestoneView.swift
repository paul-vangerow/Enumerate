//
//  MilestoneView.swift
//  Enumerate
//
//  Created by Paul on 27/06/2023.
//

import SwiftUI

struct MilestoneView: View {
    @ObservedObject var milestone: Milestone
    var group: Group
    @State private var currentPage = -1
    
    @State private var returnPoint: Int = 0
    
    var progress: CGFloat {
        CGFloat(milestone.localCardCompletion) / CGFloat(milestone.cardSizeValue)
    }
    
    @FocusState private var isEditing: Bool
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                HeadingText(text: "Milestone " + String( (milestone.id + 1) * 10), size: 40, color: true)
                    .padding(.top)
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("Border"),lineWidth: 3)
                    .background {
                        ProgressBar(completion: progress, width: 380, height: 10, roundedness: 20, extra: 25)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: 360, height: 25)
                Spacer()
                HeadingText(text: (String(currentPage + 1) + " of " + String(milestone.cards.count)), size: 20, color: true)
                Spacer().frame(height: 35)
            }
            .ignoresSafeArea(.keyboard)
            VStack {
                Spacer().frame(height: 100)
                TabView(selection: $currentPage) {
                    ForEach(milestone.cards) { card in
                        CardView(milestone: milestone, currentCard: card, isEditing: $isEditing)
                    }
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
                HStack {
                    Button( action: { returnToFront() } ){
                        if currentPage >= 10 {
                            HeadingText(text: "<<<")
                        }
                    }.frame(width: 120)
                    Spacer().frame(width: 110)
                    Button( action: { backToReturn() } ){
                        if returnPoint >= 10 {
                            HeadingText(text: ">>>")
                        }
                    }
                    .frame(width: 120)
                }
                .frame(width: 350, height: 30)
                .ignoresSafeArea(.keyboard)
            }
            .onChange(of: milestone.localCardCompletion) { _ in
                if milestone.milestoneState == .DONE {
                    currentPage = 0
                }
                if milestone.milestoneState == .PROGRESS && currentPage < milestone.cardSizeValue - 1 {
                    withAnimation(.linear(duration: 0.2)) {
                        currentPage += 1
                    }
                }
            }
            .onChange(of: currentPage) { newPage in
                isEditing = false
                let text = milestone.cards[newPage].card.pair.first
                
                if let speaker = group.speaker {
                    if milestone.cards[newPage].card.type == .TranslateCard && !milestone.cards[newPage].orientation {
                        return;
                    }
                    
                    speaker.textSpeak(string: text)
                }
            }
            .onAppear {
                currentPage = 0
            }
        }
    }
    
    func returnToFront(){
        withAnimation(.linear(duration: 0.3)) {
            returnPoint = currentPage
            currentPage = 0
        }
    }
    
    func backToReturn(){
        withAnimation(.linear(duration: 0.3)) {
            currentPage = returnPoint
            returnPoint = 0
        }
    }
}

struct MilestoneView_Previews: PreviewProvider {
    static var previews: some View {
        MilestoneView(milestone: Group.PreSpanish.milestones[0], group: Group.PreSpanish)
    }
}
