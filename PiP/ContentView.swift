//
//  ContentView.swift
//  PiP
//
//  Created by Dufaux, Damiaan on 16/01/2025.
//

import SwiftUI
import AVFoundation
import AVKit

struct ContentView: View {
    @State var controller = Controller(player: AVPlayer(playerItem: item5))
    @State var avs = (loadBuffer: [CMTimeRange](), seekBuffer: [CMTimeRange](), head: CMTime.zero, rate: Float.zero)
        
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var invalidSeekable: Bool {
        for buffer in avs.seekBuffer {
            if buffer.end == .invalid {
                return true
            }
        }
        return false
    }

    var body: some View {
        VStack {
            HStack {
                Button("Play/Pause", action: controller.togglePlay)
                Button("TogglePiP", action: controller.togglePiP)
            }.padding()
            
            HStack {
                if #available(iOS 15.0, *) {
                    Text("Rate: \(avs.rate, format: .number.precision(.fractionLength(1)))")
                }
                if invalidSeekable {
                    Text("Broken seek ‼️").hoverEffect(.highlight)
                } else {
                    Text("Seekrange: OK ✅")
                }
            }
            
            RangeView(head: avs.head, loadedRanges: avs.loadBuffer, seekableRanges: avs.seekBuffer)
                        
            PlayerView(controller: controller)
                .aspectRatio(16/9, contentMode: .fit)
                .onReceive(timer, perform: { _ in
                    if let item = controller.player.currentItem {
                        avs = (item.loadedTimeRanges.map(\.timeRangeValue), item.seekableTimeRanges.map(\.timeRangeValue), item.currentTime(), controller.player.rate)
                    } else {
                        avs = ([], [], .zero, .zero)
                    }
                })
        }
    }
}

let item1 = AVPlayerItem(url: URL(string: "https://ll-hls-test.cdn-apple.com/llhls4/ll-hls-test-04/multi.m3u8")!)
let item2 = AVPlayerItem(url: URL(string: "https://theolive-dev.global.ssl.fastly.net/europe-west/e2c4220c-3cf4-4499-ab3a-ea5e904d0406/develop/hls/main.m3u8")!)
let item3 = AVPlayerItem(url: URL(string: "https://llhls-demo.ovenmediaengine.com/app/stream/llhls.m3u8")!)
let item4 = AVPlayerItem(url: URL(string: "https://cdn-vos-ppp-01.vos360.video/Content/HLS_HLSCLEAR/Live/channel(PPP-LL-2HLS)/index.m3u8")!)
let item5 = AVPlayerItem(url: URL(string: "https://stream.mux.com/v69RSHhFelSm4701snP22dYz2jICy4E4FUyk02rW4gxRM.m3u8")!)
let item6 = AVPlayerItem(url: URL(string: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8")!)

#Preview {
    ContentView()
}
