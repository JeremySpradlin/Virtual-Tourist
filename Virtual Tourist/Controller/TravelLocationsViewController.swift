//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 1/27/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlet Declarations
    @IBOutlet weak var mapView: MKMapView!
    
    //Mark: Variable Declarations
    var oldPins: [Pin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Check to see if any previous map location data is stored, and if so, set the map to the previous stored location.
        mapView.delegate = self
        if let storedLatitudeDelta = UserDefaults.standard.value(forKey: "storedLatitudeDelta") {
            if let storedLongitudeDelta = UserDefaults.standard.value(forKey: "storedLongitudeDelta") {
                if let storedLat = UserDefaults.standard.value(forKey: "storedLat") {
                    if let storedLong = UserDefaults.standard.value(forKey: "storedLong") {
                        setMapRegion(storedLatitudeDelta as! Double, storedLongitudeDelta as! Double, lat: storedLat as! Double, long: storedLong as! Double)
                    }
                }
            }
        }
        
        //Obtain old pins from Core Data and set them in a variable for the mapview to add
        let oldPins = loadOldPins()
        if oldPins != nil {
            for pin in oldPins! {
                let coord = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                let pinToAdd = MKPointAnnotation()
                pinToAdd.coordinate = coord
                mapView.addAnnotation(pinToAdd)
            }
        }
    }
    //This IBAction is called whenever a long press gesture is recognized.  It will get the location that the long press was recognized on, convert it to coordinates, and then add an annotation at said location.
    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {

        let location = sender.location(in: self.mapView)
        let locationCoord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()

        annotation.coordinate = locationCoord
        savePin(pin: annotation)
        self.mapView.addAnnotation(annotation)

    }
    
    //This mapkit function will detect whenever an annotation is tapped, and will seque to the photo album view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
        
        vc.pin = view.annotation!
        FlickrClient.sharedInstance().pinLat = Double((view.annotation?.coordinate.latitude)!)
        FlickrClient.sharedInstance().pinLong = Double((view.annotation?.coordinate.longitude)!)
        
        
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

extension TravelLocationsViewController {

    //This function will take in the lat and long and deltas and set the maps location upon loading.
    func setMapRegion(_ latDelta: Double, _ longDelta: Double, lat: Double, long: Double) {
        mapView.region.span.latitudeDelta = latDelta
        mapView.region.span.longitudeDelta = longDelta
        mapView.region.center.latitude = lat
        mapView.region.center.longitude = long
    }

    //This function will store the current map lat/long and delta and store it in user defaults
    func storeMap() {
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "storedLatitudeDelta")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "storedLongitudeDelta")
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "storedLat")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "storedLong")
    }
    
    //This function will return the CoreDataStack for use within the code
    func getDataStack() -> CoreDataStack {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack!
    }
    
    //This function will read CoreData and load the pins to the mapview
    func loadOldPins() -> [Pin]? {

        var pins: [Pin] = []
        
        do {
            let fetchedResultsController = getFetchedResultsController()
            try fetchedResultsController.performFetch()
            let pinCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            for index in 0..<pinCount {
                pins.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Pin)
            }
            return pins
        } catch {
            print("Loading Old Pins")
            return nil
        }
        
    }
    
    //This function creates the Fetch Results Controller
    func getFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let stack = getDataStack()
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = []
        return NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func savePin(pin: MKAnnotation) {
        
        let coord = pin.coordinate
        let pin = Pin(latitude: coord.latitude, longitude: coord.longitude, context: getDataStack().context)
        do{
            try getDataStack().saveContext()
        } catch {
            print("Error Saving Pin")
        }
        oldPins.append(pin)
        
    }
}

