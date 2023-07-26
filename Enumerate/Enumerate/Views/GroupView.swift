//
//  GroupView.swift
//  Enumerate
//
//  Created by Paul on 26/06/2023.
//

import SwiftUI

struct GroupView: View {
    @ObservedObject var currentGroup: Group
    @State var available: [(Int, Milestone)] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                VStack {
                    GroupCard(group: currentGroup)
                    Spacer()
                        .frame(height: 40)
                    ScrollView {
                        ForEach (available, id: \.0) { item in
                            if item.1.milestoneState != .UNAVAILABLE {
                                NavigationLink(destination: MilestoneView(milestone: item.1, group: currentGroup)) {
                                    MilestoneCard(mileStone: item.1)
                                    
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            available = []
            var i = 0
            for item in currentGroup.milestones {
                available.append( (i, item) )
                i += 1
            }
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(currentGroup: Group.PreSpanish)
    }
}
