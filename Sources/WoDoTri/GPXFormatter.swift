//  Copyright © 2018 Markus Staas. All rights reserved.

import Foundation

final class GPXFormatter {

    private let workoutType: WorkoutType!
    private let locationHistory: Set<WorkoutLocation>!
    private let workoutStartedAt: Date!

    init(workoutType: WorkoutType, locationHistory: Set<WorkoutLocation>, workoutStartedAt: Date) {
        self.workoutType = workoutType
        self.locationHistory = locationHistory
        self.workoutStartedAt = workoutStartedAt
    }

    func makeGPX() -> String {
        let timeStampFormatter = DateFormatter()
        timeStampFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        let workoutDate = timeStampFormatter.string(from: workoutStartedAt)
        var gpxString = """
        <?xml \(GPXFormatterConstants.Key.XMLVersion)=\"\(GPXFormatterConstants.Value.XMLVersion)\" \(GPXFormatterConstants.Key.Encoding)=\"\(GPXFormatterConstants.Value.Encoding)\" ?>
        <gpx \(GPXFormatterConstants.Key.GPXVersion)=\"\(GPXFormatterConstants.Value.GPXVersion)\" \(GPXFormatterConstants.Key.Creator)=\"\(GPXFormatterConstants.Value.Creator)\" \(GPXFormatterConstants.Key.XMLNS)=\"\(GPXFormatterConstants.Value.XMLNS)\" \(GPXFormatterConstants.Key.XSI)=\"\(GPXFormatterConstants.Value.XSI)\" \(GPXFormatterConstants.Key.SchemaLocation)=\"\(GPXFormatterConstants.Value.SchemaLocation)\" \(GPXFormatterConstants.Key.GPXTPX)=\"\(GPXFormatterConstants.Value.GPXTPX)\" \(GPXFormatterConstants.Key.GPXX)=\"\(GPXFormatterConstants.Value.GPXX)\" >
        <metadata><time>\(workoutDate)</time></metadata>
        <trk><activity_type>\(workoutType!)</activity_type>
        <trkseg>

        """
        for location in locationHistory.sorted(by: ({$0.timestamp < $1.timestamp})) {
            let formattedTimeStamp = timeStampFormatter.string(from: location.timestamp)
            let newLine: String = String("""
                <trkpt lat=\"\(String(format: "%.6f", location.latitude))\" lon=\"\(String(format: "%.6f", location.longitude))\"><time>\(formattedTimeStamp)</time></trkpt>

                """)
            gpxString.append(contentsOf: newLine)
        }
        gpxString.append("</trkseg></trk></gpx>")
        return gpxString
    }
}
