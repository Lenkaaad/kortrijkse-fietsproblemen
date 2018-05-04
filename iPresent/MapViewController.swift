//
//  MapViewController.swift
//  iPresent
//
//  Created by Milenka Derumeaux on 23/04/2018.
//  Copyright © 2018 Milenka Derumeaux. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    // JSON dataset
    let url:URL = URL(string:"https://data.kortrijk.be/mobiliteit/fietspompen_en_zuilen.json")!
    
    // array for locations (struct)
    var locations:[Item] = []
    
    // mapView & location manager
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myMap.delegate = self;
        
        // navigationbar without background image + white buttons/title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true;
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        myMap.showsUserLocation = true
        
        // load in JSON
        loadJSON();
        
        myMap.centerCoordinate = CLLocationCoordinate2D(latitude: 50.828, longitude: 3.2649)
        // change centercoordinate to current location!
        
        // region make
        let region = MKCoordinateRegionMakeWithDistance(myMap.centerCoordinate, 800, 800)
        myMap.region = region;
        
        // ask for authorisation from the user for location
        self.locationManager.requestAlwaysAuthorization()
        
        // ask for authorisation for when the app is open
        self.locationManager.requestWhenInUseAuthorization()
        
        // if enabled: set up delegate, accuracy and update
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // after updating location: save in userLocation variable
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("location = \(locValue.latitude) \(locValue.longitude)");
        
        myMap.centerCoordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude);
    }
    
    func loadJSON(){
        let jsonTask = URLSession.shared.dataTask(with: url, completionHandler: completeHandler)
        jsonTask.resume()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // create anotationview
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "bikeIcon") {
            annotationView.annotation = annotation
            return annotationView
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "bikeIcon")

        // setup annotationview
        annotationView.annotation = annotation;
        annotationView.canShowCallout = true;
        annotationView.image = UIImage(named: "mapColor");
        annotationView.frame.size = CGSize(width: 40, height: 53)
        return annotationView
    }
    
    func completeHandler(data: Data?, response: URLResponse?, error: Error?){
        
        let decoder = JSONDecoder();
        do {
            let decodedObject = try decoder.decode([Item].self, from: data!)
            
            locations = (decodedObject)
            
            DispatchQueue.main.async {
                // loop over each location + create point annotation
                self.locations.forEach { item in
                    let annotation = MKPointAnnotation()
                    annotation.title = item.wat
                    annotation.subtitle = item.locatienaam
                    annotation.coordinate = CLLocationCoordinate2D(latitude: item.NB, longitude: item.OL)
                    self.myMap.addAnnotation(annotation);
                }
            }
            
        } catch let error {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
