//
//  DetailViewController.swift
//  iPresent
//
//  Created by Milenka Derumeaux on 01/05/2018.
//  Copyright © 2018 Milenka Derumeaux. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    // outlets for labels & image
    @IBOutlet weak var watLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var staatLabel: UILabel!
    @IBOutlet weak var activiteitsLabel: UITextView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    
    //
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var currentDetail: Item? {
        // if currentDetail is set, show all info
        didSet{
            showInfoDetail();
        }
    }
    
    func checkIfExists() {
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            // als er een waarde is
            let allDetails = try? PropertyListDecoder().decode(Array<Item>.self, from: data);
            
            // loop over alle waarden + verander eventueel exists value
            for onedetail in allDetails! {
                if onedetail.locatienaam == currentDetail?.locatienaam {
                self.favButton.setBackgroundImage(#imageLiteral(resourceName: "heartfilled"), for: .normal)
                    print("Already in favorites");
                }
            }
        }
    }
    
    func showInfoDetail(){
        if let detail = currentDetail{
            DispatchQueue.main.async {
                // remove activityindicator
                self.activityIndicator.removeFromSuperview()
                
                self.myMap.centerCoordinate = CLLocationCoordinate2D(latitude: detail.NB, longitude: detail.OL)
                
                let region = MKCoordinateRegionMakeWithDistance(self.myMap.centerCoordinate, 200, 200)
                self.myMap.region = region;
                
                // fill in all labels
                self.locationLabel.text = detail.locatienaam
                self.watLabel.text = detail.wat.uppercased()
                self.staatLabel.text = detail.straat
                self.activiteitsLabel.text = detail.activiteit
                self.distanceLabel.text = "\(Int(detail.distance!)) m"
                
                if Int(detail.distance!) < 1000 {
                    self.distanceLabel.text = "\(Int(detail.distance!)) m"
                }else{
                    self.distanceLabel.text = "\(Double(round(detail.distance!)/1000)) km"
                }
                
                let annotation = MKPointAnnotation()
                annotation.title = detail.wat
                annotation.subtitle = detail.locatienaam
                annotation.coordinate = CLLocationCoordinate2D(latitude: detail.NB, longitude: detail.OL)
                self.myMap.addAnnotation(annotation);
                
                // switch for right icon
                switch detail.wat {
                case "fietspomp elektrisch":
                    self.locationImage.image = UIImage(named: "pomp-1");
                case "fietspomp mechanisch":
                    self.locationImage.image = UIImage(named: "pomp-2");
                case "fietsreparatiezuil":
                    self.locationImage.image = UIImage(named: "fiets-1");
                case "bewaakte fietsstalling":
                    self.locationImage.image = UIImage(named: "fiets-2");
                case "fiets huren":
                    self.locationImage.image = UIImage(named: "fiets-3");
                default:
                    self.locationImage.image = UIImage(named: "default");
                }
            }
        }
    }
    
    
    @IBAction func addToFavorites(_ sender: UIButton) {
       if let detail = currentDetail{
        
        var exists:Bool = false;
        // uitlezen & decoden van favorites lokaal
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            // als er een waarde is
            var allDetails = try? PropertyListDecoder().decode(Array<Item>.self, from: data);
            
            // loop over alle waarden + verander eventueel exists value
            for onedetail in allDetails! {
                if onedetail.locatienaam == detail.locatienaam {
                    exists = true;
                }
            }
            
            // als de value nog niet bestaat, append nieuwe detail + push to userdefaults
            if !exists {
                allDetails?.append(detail);
                UserDefaults.standard.set(try? PropertyListEncoder().encode(allDetails), forKey:"favorites");
                self.favButton.setBackgroundImage(#imageLiteral(resourceName: "heartfilled"), for: .normal)

            }else{
                allDetails = allDetails?.filter { $0.locatienaam != currentDetail?.locatienaam }
                UserDefaults.standard.set(try? PropertyListEncoder().encode(allDetails), forKey:"favorites");
                
                self.favButton.setBackgroundImage(#imageLiteral(resourceName: "heart"), for: .normal)
            }
            
            print(detail);
        }else{
            // als er nog geen data inzit
            let allDetails = [detail];
            UserDefaults.standard.set(try? PropertyListEncoder().encode(allDetails), forKey:"favorites");
            self.favButton.setBackgroundImage(#imageLiteral(resourceName: "heartfilled"), for: .normal)
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myMap.delegate = self;
        myMap.showsUserLocation = false;
    
        // set gradient background
        setGradientBackground()
        
        favButton.setBackgroundImage(#imageLiteral(resourceName: "heart"), for: .normal)
        
        checkIfExists();
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
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 98.0/255.0, green: 120.0/255.0, blue: 208.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 117.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
