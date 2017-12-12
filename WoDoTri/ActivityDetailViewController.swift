//
//  ActivityDetailViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 12/4/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import MapKit

class ActivityDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var activityTypeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var completedDistanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var activity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        let distance = Measurement(value: activity.distance, unit: UnitLength.meters)
        let seconds = Int(activity.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(activity.timestamp)
        let formattedTime = activity.duration
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)
        activityTypeLabel.text = activity.type
        completedDistanceLabel.text = "Distance:  \(formattedDistance)"
        dateLabel.text = formattedDate
        elapsedTimeLabel.text = "Time:  \(formattedTime)"
        avgPaceLabel.text = "Pace:  \(formattedPace)"
        loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = activity.locations,
            locations.count > 0
            else {
                print("No locations found")
                return nil
        }
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3, longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> MKPolyline {
        
        guard let locations = activity.locations else {
            return MKPolyline()
        }
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }

        return MKPolyline(coordinates: coords, count: coords.count)
        
    }
    private func loadMap() {
        guard
            let locations = activity.locations,
            locations.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(title: "Error", message: "Sorry, this run has no locations saved", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.add(polyLine())
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .purple
        renderer.lineWidth = 4
        return renderer
    }
}
