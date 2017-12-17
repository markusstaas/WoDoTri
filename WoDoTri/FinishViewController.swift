//
//  FinishViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/12/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MapKit

class FinishViewController: UIViewController, MKMapViewDelegate, OverlayViewController {
    
    let overlaySize: CGSize? = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
 
    
    var activity: Activity!
    let workoutData = WorkoutData.shared
    var subContext = CoreDataStack.context
    let stopwatch = StopWatch()
    var activityDuration: String?
    var finalTimestamp: Date?
    var coords = [CLLocationCoordinate2D]()

    @IBOutlet weak var activityTypeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var completedDistanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityTypeLabel.text = workoutData.activityType.description
        elapsedTimeLabel.text = "Duration: \(workoutData.duration)"
        completedDistanceLabel.text = "Distance: \(workoutData.distanceString())"
        avgPaceLabel.text = "Average speed: \(workoutData.avgPaceString())"
       
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: subContext)
       
        for location in workoutData.locationList {
            let coordItem: CLLocationCoordinate2D = location.coordinate
            coords.append(coordItem)
        }
         loadMap()
    }
    @IBAction func continueButtonPressed() {
        dismissOverlay()
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        saveActivity()
    }
    @IBAction func discardButtonPressed(_ sender: Any) {
        stopwatch.reset()
    }
    
    @objc func managedObjectContextDidSave(notification: NSNotification) {
        if notification.name == NSNotification.Name.NSManagedObjectContextDidSave {
            let alert = UIAlertController(title: "Workout Saved", message: "Your workout has been saved. Tap OK to return to the start screen", preferredStyle: .actionSheet)
            let savedAction = UIAlertAction(title: "OK", style: .default) { [unowned self] action in
                self.performSegue(withIdentifier: "homeSegue", sender: self)
                self.navigationController?.popViewController(animated: false)
            }
            alert.addAction(savedAction)
            present(alert, animated: true)

        }
    }
    //////Core Data
    private func saveActivity() {
        let newActivity = Activity(context: CoreDataStack.context)
        newActivity.distance = workoutData.distance.value
        newActivity.duration = workoutData.duration
        newActivity.type = workoutData.activityType.description
        newActivity.timestamp = Date()

        for location in workoutData.locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newActivity.addToLocations(locationObject)
            
        }
        CoreDataStack.saveContext()
        activity = newActivity
    }

    private func mapRegion() -> MKCoordinateRegion? {
  
        let latitudes = coords.map { location -> Double in
            let location = location
            print(location.latitude)
            return location.latitude
        }
        
        let longitudes = coords.map { location -> Double in
            let location = location
            print(location.longitude)
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
        
        return MKPolyline(coordinates: coords, count: coords.count)
        
    }
    private func loadMap() {
        
        guard
            coords.count > 0,
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
