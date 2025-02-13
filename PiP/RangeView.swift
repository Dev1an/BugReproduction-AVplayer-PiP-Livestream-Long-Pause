import SwiftUI
import CoreMedia
import Charts

struct RangeView: View {
    let head: CMTime
    let loadedRanges: [CMTimeRange]
    let seekableRanges: [CMTimeRange]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Chart {
                PointMark(x: .value("playhead", head.seconds)).annotation(position: .trailing) {
                    Text("\(head.seconds, format: .number.precision(.fractionLength(1)))")
                }
                ForEach(loadedRanges, id: \.start) { buffer in
                    BarMark(
                        xStart: .value("bufstart", buffer.start.seconds),
                        xEnd: .value("bufend", buffer.end.seconds),
                        y: .value("buftype", "Loaded")
                    ).annotation(position: .trailing) {
                        Text("\(buffer.end.seconds, format: .number.precision(.fractionLength(1)))")
                    }
                }
                ForEach(seekableRanges, id: \.start) { buffer in
                    BarMark(
                        xStart: .value("bufstart", buffer.start.seconds),
                        xEnd: .value("bufend", buffer.end.seconds),
                        y: .value("buftype", "Seekable")
                    )
                }
            }
        }
    }
}

#Preview {
    RangeView(
        head: .init(seconds: 2, preferredTimescale: 1000),
        loadedRanges: [
            .init(
                start: .init(seconds: 0, preferredTimescale: 1000),
                end: .init(seconds: 8, preferredTimescale: 1000)
            )
        ],
        seekableRanges: [
            .init(
                start: .init(seconds: 6, preferredTimescale: 1000),
                end: .init(seconds: 7, preferredTimescale: 1000)
            )
        ]
    )
}
