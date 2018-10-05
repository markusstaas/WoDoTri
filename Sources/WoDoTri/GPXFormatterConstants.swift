//  Copyright © 2018 Markus Staas. All rights reserved.

struct GPXFormatterConstants {

    struct Key {
        static let XMLVersion = "version"
        static let Encoding = "encoding"
        static let Creator = "creator"
        static let GPXVersion = "version"
        static let XMLNS = "xmlns"
        static let XSI = "xmlns:xsi"
        static let SchemaLocation = "xsi:schemaLocation"
        static let GPXTPX = "xmlns:gpxtpx"
        static let GPXX = "xmlns:gpxx"
    }

    struct Value {
        static let XMLVersion = "1.0"
        static let Encoding = "UTF-8"
        static let Creator = "WoDoTri"
        static let GPXVersion = "1.1"
        static let XMLNS = "http://www.topografix.com/GPX/1/1"
        static let XSI = "http://www.w3.org/2001/XMLSchema-instance"
        static let SchemaLocation = "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd"
        static let GPXTPX = "http://www.garmin.com/xmlschemas/TrackPointExtension/v1"
        static let GPXX = "http://www.garmin.com/xmlschemas/GpxExtensions/v3"
    }
}
