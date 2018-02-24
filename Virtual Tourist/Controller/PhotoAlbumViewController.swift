//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 1/29/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {
    
    //MARK: Outlet Declaration
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    //MARK: Variable Declaration
    //var pin: MKAnnotation!
    var photosForPin: [Photo]!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let annotation = MKPointAnnotation()
        //annotation.coordinate = pin.coordinate
        annotation.coordinate.latitude = pin.latitude
        annotation.coordinate.longitude = pin.longitude
        let region = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.1, 0.1))
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(annotation)
        
        photosCollectionView.dataSource = self
        getPhotos()

    }
    
    //Collection View Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Inside Collection View Funcs")
        //return photosForPin.count
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    //MARK: IBAction Functions
    //This back button function will dismiss the photo album and return the user to the initial mapview
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoAlbumViewController {
    
/** TODO: Function to save photos to particular pin in Core Data **/
    func saveImages(_ photoArray: [[String:AnyObject]]) {
        
    }
    
/** TODO: Function to download photos to save and add to image view in cell **/
    
    //This function will return the CoreDataStack for use within the code
    func getDataStack() -> CoreDataStack {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack!
    }
    
    //This function creates the Fetch Results Controller
    func getFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let stack = getDataStack()
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fr.sortDescriptors = []
        return NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    //This function returns saved photos, or returns nil if no photos are saved in Coredata
    func loadSavedPhotos() -> [Photo]? {
        do {
            var photos:[Photo] = []
            let fetchedResults = getFetchedResultsController()
            try fetchedResults.performFetch()
            let numberOfPhotos = try fetchedResults.managedObjectContext.count(for: fetchedResults.fetchRequest)
            for photo in 0..<numberOfPhotos {
                photos.append(fetchedResults.object(at: IndexPath(row: photo, section: 0)) as! Photo)
            }
            return photos
        } catch {
            return nil
        }
    }

    //This function will get new photos and save it to the core data source
    func getPhotos() {
        
        FlickrClient.sharedInstance().taskForGetMethod() { (result, error) in
            
//            for photo in result! {
//                print(photo["url_m"])
//            }
//            self.saveImages(result!)
        }
    }
    
}
