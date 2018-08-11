//  Copyright © 2018 Markus Staas. All rights reserved.

struct GPXFormatterConstants {

    struct Key {
        static let XMLVersion = "version"
        static let Encoding = "encoding"
        static let GPXVersion = "version"
        static let Creator = "creator"
        static let XMLNS = "xmlns"
        static let XSI = "xmlns:xsi"
        static let GTE = "xmlns:gte"
        static let SchemaLocation = "xsi:schemaLocation"
    }

    struct Value {
        static let XMLVersion = "1.0"
        static let Encoding = "UTF-8"
        static let GPXVersion = "1.1"
        static let Creator = "WoDoTri"
        static let XMLNS = "http://www.topografix.com/GPX/1/1"
        static let XSI = "http://www.w3.org/2001/XMLSchema-instance"
        static let GTE = "http://www.gpstrackeditor.com/xmlschemas/General/1"
        static let SchemaLocation = "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd"
    }
}
