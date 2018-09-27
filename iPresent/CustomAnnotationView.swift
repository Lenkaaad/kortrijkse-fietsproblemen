//
//  CustomAnnotationView.swift
//  iPresent
//
//  Created by Milenka Derumeaux on 07/05/2018.
//  Copyright © 2018 Milenka Derumeaux. All rights reserved.
//

import UIKit

class CustomAnnotationView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var locationnameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var watLabel: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
