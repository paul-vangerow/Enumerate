//
//  ProgressBar.swift
//  Enumerate
//
//  Created by Paul on 26/06/2023.
//

import SwiftUI

struct ProgressBar: View {
    var completion: CGFloat
    var width: CGFloat
    var height: CGFloat
    var roundedness: CGFloat
    var extra: CGFloat = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
            HStack {
                Spacer()
                    .frame(maxWidth: extra)
                RoundedRectangle(cornerRadius: roundedness)
                    .fill(Color("Progress"))
                    .frame(width: ((width - (2 * extra)) * completion), height: height)
                Spacer()
                    .frame(minWidth: 0)
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(completion: 1, width: 320, height: 40, roundedness: 20)
    }
}
