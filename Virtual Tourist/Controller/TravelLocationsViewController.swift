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
    @IBOutlet weak var travelLocationsMap: MKMapView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Check to see if any previous map location data is stored, and if so, set the map to the previous stored location.
        travelLocationsMap.delegate = self
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

    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: self.travelLocationsMap)
        let locationCoord = self.travelLocationsMap.convert(location, toCoordinateFrom: self.travelLocationsMap)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationCoord
        
        self.travelLocationsMap.addAnnotation(annotation)
        addAnnotation()
    }
    
}


extension TravelLocationsViewController {
    
    //This function will take in the lat and long and deltas and set the maps location upon loading.
    func setMap(_ latDelta: Double, _ longDelta: Double, lat: Double, long: Double) {
        travelLocationsMap.region.span.latitudeDelta = latDelta
        travelLocationsMap.region.span.longitudeDelta = longDelta
        travelLocationsMap.region.center.latitude = lat
        travelLocationsMap.region.center.longitude = long
    }
    
    //This app will store the current map lat/long and delta and store it in user defaults
    func storeMap() {
        UserDefaults.standard.set(travelLocationsMap.region.span.latitudeDelta, forKey: "storedLatitudeDelta")
        UserDefaults.standard.set(travelLocationsMap.region.span.longitudeDelta, forKey: "storedLongitudeDelta")
        UserDefaults.standard.set(travelLocationsMap.region.center.latitude, forKey: "storedLat")
        UserDefaults.standard.set(travelLocationsMap.region.center.longitude, forKey: "storedLong")
    }
    
    //This function will add the annotation whenver a long press gesture is recognized.
    func addAnnotation() {
        print("addAnnotation Called")
        print(FlickrClient.sharedInstance().flickrURLFromParameters(FlickrClient.sharedInstance().buildURLParamters()))
    }
}

