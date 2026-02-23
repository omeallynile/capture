import SwiftUI

enum CameraPreviewStyle {
    case pip
    case tile
}

struct CameraPreview: View {
    let manager: CameraManager
    let style: CameraPreviewStyle

    var body: some View {
        // Optimized: Removed GeometryReader to avoid unnecessary layout calculations
        Group {
            if let image = manager.viewfinderImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                ZStack {
                    Color.black
                    Image(systemName: "camera.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
