//
//  ViewController.swift
//  iPresent
//
//  Created by Milenka Derumeaux on 19/04/2018.
//  Copyright © 2018 Milenka Derumeaux. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Buttons
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // set background gradient
        setGradientBackground();
        
        // scale image in buttons correctly
        listButton.imageView?.contentMode = .scaleAspectFit
        mapButton.imageView?.contentMode = .scaleAspectFit

        // navigationbar without background image + white buttons/title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
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

