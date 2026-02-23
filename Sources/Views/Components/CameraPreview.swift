import SwiftUI

enum CameraPreviewStyle {
    case pip
    case tile
}

struct CameraPreview: View {
    let manager: CameraManager
    let style: CameraPreviewStyle

    var body: some View {
        GeometryReader { geometry in
            Group {
                if let image = manager.viewfinderImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    ZStack {
                        Color.black
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
}
