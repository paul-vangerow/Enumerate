import Foundation
import SwiftUI

struct CompletionBanner: View {
    var height: CGFloat
    var width: CGFloat
    
    let ArrowPoints: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 1),
        CGPoint(x: 1, y: 0.5),
        CGPoint(x: 0.5, y: 0)
    ]
    
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: ArrowPoints[0].x * width, y: ArrowPoints[0].y * height) )
                
                ArrowPoints.forEach { point in
                    path.addLine(to: CGPoint(x: (point.x * width), y: (point.y * height) ))
                }
            }
            .fill(Color("Progress"))
        }
        .frame(width: width, height: height)
    }
}

struct Arrow_preview: PreviewProvider {
    static var previews: some View {
        CompletionBanner(height: 100, width: 100)
    }
}
