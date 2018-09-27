//
//  LocationsTableViewController.swift
//  iPresent
//
//  Created by Milenka Derumeaux on 21/04/2018.
//  Copyright © 2018 Milenka Derumeaux. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsTableViewCell: UITableViewCell {
    
    // outlets for in tableviewcell
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationnameLabel: UILabel!
    @IBOutlet weak var activiteitLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
}

class LocationsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    // JSON dataset
    let url:URL = URL(string:"https://data.kortrijk.be/mobiliteit/fietspompen_en_zuilen.json")!
    
    // location manager creating
    let locationManager = CLLocationManager()
    
    // array for locations (struct)
    var locations:[Item] = []
    
    // set userlocation (in case of no GPS data) (station Kortrijk)
    var userLocation = CLLocation(latitude: 50.8251224, longitude: 3.2566937)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationbar without background image + white buttons/title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
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
        
        // load in JSON
        loadJSON();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // after updating location: save in userLocation variable
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    func loadJSON(){
        let jsonTask = URLSession.shared.dataTask(with: url, completionHandler: completeHandler)
        jsonTask.resume()
        
        print("JSON LOADING");
    }
    
    func completeHandler(data: Data?, response: URLResponse?, error: Error?){

        let decoder = JSONDecoder();
        do {
            let decodedObject = try decoder.decode([Item].self, from: data!)
            
            locations = (decodedObject)
            
            // loop over locations
            for i in 0..<(locations.count) {
                // create variable with current location
                var item = locations[i];
                
                // save coordinate in CCLocation
                let coordinate = CLLocation(latitude: item.NB, longitude: item.OL)
                
                // calculate distance between user & location coordinates
                let distanceInMeters = userLocation.distance(from: coordinate);
                
                // add distance & replace location in array with new item
                item.distance = distanceInMeters;
                locations[i] = item;
            }
            
            // sort the locations by distance
            locations.sort(by: { $0.distance! < $1.distance! })
            
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
            
            
        } catch let error {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // override height to 100
        return 100;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helpCell", for: indexPath) as! LocationsTableViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(displayP3Red: 117.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
        cell.selectedBackgroundView = bgColorView

        // create cell and add values to outlets
        cell.activiteitLabel.lineBreakMode = .byWordWrapping
        cell.activiteitLabel.numberOfLines = 0
        cell.locationnameLabel?.text = locations[indexPath.row].locatienaam
        cell.activiteitLabel?.text = locations[indexPath.row].activiteit
        if (Int(locations[indexPath.row].distance!)) < 1000 {
            cell.distanceLabel?.text =  "\(Int(locations[indexPath.row].distance!)) m"
        }else{
            cell.distanceLabel?.text =  "\(Double(round(locations[indexPath.row].distance!)/1)/1000) km"
        }
        
        // switch case to show right image
        switch locations[indexPath.row].wat {
        case "fietspomp elektrisch":
            cell.locationImage.image = UIImage(named: "pomp-1");
        case "fietspomp mechanisch":
            cell.locationImage.image = UIImage(named: "pomp-2");
        case "fietsreparatiezuil":
            cell.locationImage.image = UIImage(named: "fiets-1");
        case "bewaakte fietsstalling":
            cell.locationImage.image = UIImage(named: "fiets-2");
        case "fiets huren":
            cell.locationImage.image = UIImage(named: "fiets-3");
        default:
            cell.locationImage.image = UIImage(named: "default");
        }

        // return cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // create segue
        let detailVC = segue.destination as! DetailViewController
        let selectedIndexPath = tableView.indexPathForSelectedRow
        detailVC.currentDetail = locations[(selectedIndexPath?.row)!]
        
    }

}
