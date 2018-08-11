//  Copyright © 2018 Markus Staas. All rights reserved.

import Foundation

final class GPXFormatter {
// 1. Get Values
    private let timeStamp: Date!
    private let workoutType: WorkoutType!
   // private let locationHistory: Set<WorkoutLocation>

    init(timeStamp: Date, workoutType: WorkoutType) {
        self.timeStamp = timeStamp
        self.workoutType = workoutType
      //  self.locationHistory = Set<WorkoutLocation>
    }

    func makeGPX() -> String {
        var GPXString = "<?XML \(GPXFormatterConstants.Key.XMLVersion)=\"\(GPXFormatterConstants.Value.XMLVersion)\" "
        GPXString.append("\(GPXFormatterConstants.Key.Encoding)=\"\(GPXFormatterConstants.Value.Encoding)\" ?>")
        GPXString.append("<gpx \(GPXFormatterConstants.Key.GPXVersion)=\"\(GPXFormatterConstants.Value.GPXVersion)\" ")
        GPXString.append("\(GPXFormatterConstants.Key.Creator)=\"\(GPXFormatterConstants.Value.Creator)\" ")
        GPXString.append("\(GPXFormatterConstants.Key.XMLNS)=\"\(GPXFormatterConstants.Value.XMLNS)\" ")
        GPXString.append("\(GPXFormatterConstants.Key.XSI)=\"\(GPXFormatterConstants.Value.XSI)\" ")
        GPXString.append("\(GPXFormatterConstants.Key.GTE)=\"\(GPXFormatterConstants.Value.GTE)\" ")
        GPXString.append("\(GPXFormatterConstants.Key.SchemaLocation)=\"\(GPXFormatterConstants.Value.SchemaLocation)\" >")
        GPXString.append("<trk><activity_type>\(workoutType)</activity_type></trk>")

       // for locations in locationHistory {

        //}
        print(timeStamp)
        print(workoutType)
        return GPXString
    }

    //    private func createStravaFile() {
    //        let timeStampFormatter = DateFormatter()
    //        timeStampFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
//            var gpxText: String = String("""
//                <?xml version=\"1.0\" encoding=\"UTF-8\"?><gpx version=\"1.1\"
//                creator=\"WoDoTri\" xmlns=\"http://www.topografix.com/GPX/1/1\"
//                xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
//                xmlns:gte=\"http://www.gpstrackeditor.com/xmlschemas/General/1\"
//                xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">
//                <trk><activity_type>\"Ride\"</activity_type><trkseg>
//                """)
    //
    //        for locations in workout.locationList {
    //            //let formattedTimeStamp = timeStampFormatter.date(from: String(describing: locations.timestamp))
    //            let formattedTimeStamp = timeStampFormatter.string(from: locations.timestamp)
    //            let newLine: String = String("""
    //                <trkpt lat=\"\(String(format: "%.6f", locations.coordinate.latitude))\
    //                " lon=\"\(String(format: "%.6f", locations.coordinate.longitude))\">
    //                <time>\(formattedTimeStamp)</time></trkpt>
    //                """)
    //            gpxText.append(contentsOf: newLine)
    //        }
    //
    //        gpxText.append("</trkseg></trk></gpx>")

}
