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

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, MKMapViewDelegate {
    
    //MARK: Outlet Declaration
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    //MARK: Variable Declaration
    var pin: MKAnnotation!
//    var lat: Double!
//    var long: Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        let region = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.1, 0.1))
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(annotation)
    }
    
    
    
}
