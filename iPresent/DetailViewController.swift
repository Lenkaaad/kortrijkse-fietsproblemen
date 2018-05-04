//
//  DetailViewController.swift
//  iPresent
//
//  Created by Milenka Derumeaux on 01/05/2018.
//  Copyright © 2018 Milenka Derumeaux. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // outlets for labels & image
    @IBOutlet weak var watLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var staatLabel: UILabel!
    @IBOutlet weak var activiteitsLabel: UITextView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    
    //
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var currentDetail: Item? {
        // if currentDetail is set, show all info
        didSet{
            showInfoDetail()
        }
    }
    
    func showInfoDetail(){
        if let detail = currentDetail{
            DispatchQueue.main.async {
                // remove activityindicator
                self.activityIndicator.removeFromSuperview()
                
                // fill in all labels
                self.locationLabel.text = detail.locatienaam
                self.watLabel.text = detail.wat.uppercased()
                self.staatLabel.text = detail.straat
                self.activiteitsLabel.text = detail.activiteit
                self.distanceLabel.text = "\(Int(detail.distance!)) m"
                
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set gradient background
        setGradientBackground()
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
