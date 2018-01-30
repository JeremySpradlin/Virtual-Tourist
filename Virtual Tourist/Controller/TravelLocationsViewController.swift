//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 1/27/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlet Declarations
    @IBOutlet weak var mapView: MKMapView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Check to see if any previous map location data is stored, and if so, set the map to the previous stored location.
        mapView.delegate = self
        if let storedLatitudeDelta = UserDefaults.standard.value(forKey: "storedLatitudeDelta") {
            if let storedLongitudeDelta = UserDefaults.standard.value(forKey: "storedLongitudeDelta") {
                if let storedLat = UserDefaults.standard.value(forKey: "storedLat") {
                    if let storedLong = UserDefaults.standard.value(forKey: "storedLong") {
                        setMap(storedLatitudeDelta as! Double, storedLongitudeDelta as! Double, lat: storedLat as! Double, long: storedLong as! Double)
                    }
                }
            }
        }
    }
    //This IBAction is called whenever a long press gesture is recognized.  It will get the location that the long press was recognized on, convert it to coordinates, and then add an annotation at said location.
    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {

        let location = sender.location(in: self.mapView)
        let locationCoord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()

        annotation.coordinate = locationCoord

        self.mapView.addAnnotation(annotation)
        addAnnotation()
    }
    
    //This mapkit function will detect whenever an annotation is tapped, and will seque to the photo album view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Pin Selected!")
        print(view.annotation?.coordinate)
    }
    
    
}


extension TravelLocationsViewController {

    //This function will take in the lat and long and deltas and set the maps location upon loading.
    func setMap(_ latDelta: Double, _ longDelta: Double, lat: Double, long: Double) {
        mapView.region.span.latitudeDelta = latDelta
        mapView.region.span.longitudeDelta = longDelta
        mapView.region.center.latitude = lat
        mapView.region.center.longitude = long
    }

    //This app will store the current map lat/long and delta and store it in user defaults
    func storeMap() {
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "storedLatitudeDelta")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "storedLongitudeDelta")
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "storedLat")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "storedLong")
    }

    //This function will add the annotation whenver a long press gesture is recognized.
    func addAnnotation() {
        print("addAnnotation Clicked!")
    }
}

