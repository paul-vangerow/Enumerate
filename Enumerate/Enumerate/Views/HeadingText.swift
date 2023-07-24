//
//  HeadingText.swift
//  Quantify
//
//  Created by Paul on 16/07/2023.
//

import SwiftUI

struct HeadingText: View {
    var text: String
    var size: CGFloat = 20
    var color: Bool = true
    
    var body: some View {
        Text(text)
            .font(.system(size: size, weight: .bold, design: .rounded))
            .foregroundColor( color ? Color("StandardBGText") : Color("WhiteBGText"))
    }
}
