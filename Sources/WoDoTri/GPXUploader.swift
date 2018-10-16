//  Copyright © 2018 Markus Staas. All rights reserved.

import Foundation
import Alamofire

final class GPXUploader {

    private let gpxString: String
    private let defaults = UserDefaults.standard

    init(gpxString: String) {
        self.gpxString = gpxString
    }

    func uploadWorkoutToStrava() {

            let stravaToken = defaults.value(forKey: "StravaToken")
            let uploadUrl = "https://www.strava.com/api/v3/uploads"
            let headers: HTTPHeaders = [ "Authorization": "Bearer \(stravaToken!)"]
            let parameters: Parameters = [
                "file": "@file.gpx",
                "data_type": "gpx"
                        ]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let gpxSubmitData = self.gpxString.data(using: .utf8) {
                multipartFormData.append(
                    gpxSubmitData,
                    withName: "file",
                    fileName: "file.gpx",
                    mimeType: "application/gpx"
                )
            }
        }, usingThreshold: UInt64.init(),
           to: uploadUrl,
           method: .post,
           headers: headers,
           encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.description)
                    if let err = response.error {
                        print(err)
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                print(error)
            }
        }
        )
    }
}
