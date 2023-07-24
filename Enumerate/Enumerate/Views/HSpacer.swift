//
//  HSpacer.swift
//  Quantify
//
//  Created by Paul on 16/07/2023.
//

import SwiftUI

struct HSpacer: View {
    var height: CGFloat
    
    var body: some View {
        Spacer()
            .frame(height: height)
    }
}
