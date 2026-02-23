import SwiftUI

struct AudioVisualizerView: View {
    let powerLevel: Float

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<10) { _ in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.red.opacity(0.8))
                    .frame(width: 4, height: max(5, CGFloat(powerLevel) * 50 + CGFloat.random(in: 0...10)))
                    .animation(.easeInOut(duration: 0.1), value: powerLevel)
            }
        }
        .frame(height: 60)
    }
}
