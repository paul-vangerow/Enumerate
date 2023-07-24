//
//  GroupCard.swift
//  Enumerate
//
//  Created by Paul on 19/06/2023.
//

import SwiftUI

struct GroupCard: View {
    @ObservedObject var group: Group
    
    var body: some View {
        ZStack {
            if let imageData = group.groupImage {
                if let imageVal = UIImage(data: imageData) {
                    Image(uiImage: imageVal)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("WhiteBGText"))
                }
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("WhiteBGText"))
            }
            
            HeadingText(text: group.groupName, size: 30)
                .shadow(radius: 10)
        }
        .shadow(radius: 3)
        .frame(width: 320, height: 180)
    }
}

struct GroupCard_Previews: PreviewProvider {
    static var previews: some View {
        GroupCard(group: Group.PreSpanish)
    }
}
