//
//  MilestoneView.swift
//  Enumerate
//
//  Created by Paul on 27/06/2023.
//

import SwiftUI

struct MilestoneView: View {
    @ObservedObject var milestone: Milestone
    @State private var currentPage = 0
    
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
                Spacer()
                    .frame(height: 35)
            }
            VStack {
                Spacer().frame(height: 30)
                TabView(selection: $currentPage) {
                    ForEach(milestone.cards) { card in
                        CardView(milestone: milestone, currentCard: card, isEditing: $isEditing)
                    }
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
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
            .onChange(of: currentPage) { _ in
                isEditing = false
            }
        }
    }
}

struct MilestoneView_Previews: PreviewProvider {
    static var previews: some View {
        MilestoneView(milestone: Group.PreSpanish.milestones[0])
    }
}
