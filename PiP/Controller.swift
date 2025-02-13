import AVKit

struct Controller {
    let player: AVPlayer
    let layer: AVPlayerLayer
    let pip: AVPictureInPictureController?
    let pipDelegate: PipDelegate
    
    init(player: AVPlayer) {
        self.player = player
        player.automaticallyWaitsToMinimizeStalling = false
        self.layer = AVPlayerLayer(player: player)
        pipDelegate = PipDelegate()
        if let pipController = AVPictureInPictureController(playerLayer: layer) {
            pip = pipController
            pip?.delegate = pipDelegate
        } else {
            print("Pip not supported")
            pip = nil
        }
    }
    
    func togglePiP() {
        if let pip {
            if pip.isPictureInPictureActive {
                pip.stopPictureInPicture()
            } else {
                pip.startPictureInPicture()
            }
        } else {
            print("pip not supported 2")
        }
    }
    
    func togglePlay() {
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
        }
    }
    
    class PipDelegate: NSObject, AVPictureInPictureControllerDelegate {
        func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: any Error) {
            print("failed to start pip")
        }
    }
}

import SwiftUI
struct PlayerView: UIViewRepresentable {
    let controller: Controller

    func makeUIView(context: Context) -> PlayerUIView {
        PlayerUIView(controller: controller)
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: Context) {}
}

class PlayerUIView: UIView {
    /// The player that is streched out to fit this view
    let controller: Controller
    
    required init?(coder: NSCoder) {nil}
    
    /// Create a container view that holds a `THEOPlayer` and lays it out
    /// to stretch its contents to fill the entire frame of the container view.
    /// - Parameter player: The player that will be laid out in this view
    init(controller: Controller) {
        self.controller = controller
        super.init(frame: .zero)
        layer.addSublayer(controller.layer)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        controller.layer.frame = bounds
    }
}
