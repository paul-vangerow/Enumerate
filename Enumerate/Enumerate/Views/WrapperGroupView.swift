//
//  WrapperGroupView.swift
//  Enumerate
//
//  Created by Paul on 02/07/2023.
//

import SwiftUI

struct WrapperGroupView: View {
    @ObservedObject var groupToPresent: Group
    @State private var editing = false
    @State private var accessing = false
    
    var body: some View {
        NavigationStack {
            Button ( action: {} ){
                GroupCard(group: groupToPresent)
            }
            .buttonStyle(ScrollViewGestureButtonStyle(longPressAction: gestureOccured))
        }
        .navigationDestination(isPresented: $editing){
            GroupEdit(originalGroup: groupToPresent)
        }
        
        .navigationDestination(isPresented: $accessing){
            GroupView(currentGroup: groupToPresent)
        }
    }
    
    func gestureOccured( interval: TimeInterval ) -> Void {
        if (interval < 0.3){
            accessing = true
        } else {
            editing = true
        }
    }
}

struct ScrollViewGestureButtonStyle: ButtonStyle {
    @State private var currTime = Date()

    init(longPressAction: @escaping (_: TimeInterval) -> Void) {
        self.longPressAction = longPressAction
    }

    private var longPressAction: (_: TimeInterval) -> Void

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    currTime = Date()
                } else {
                    longPressAction(Date().timeIntervalSince(currTime))
                }
            }
    }
}

struct WrapperGroupView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperGroupView(groupToPresent: Group.PreSpanish)
    }
}
