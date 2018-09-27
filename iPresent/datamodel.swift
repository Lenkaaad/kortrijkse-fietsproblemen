//
//  datamodel.swift
//  iPresent
//
//  Copyright © 2018 Milenka Derumeaux. All rights reserved.
//

import Foundation
import CoreLocation

struct Item:Codable {
    var wat:String
    var url:String
    var locatienaam:String
    var straat:String
    var NB:Double
    var OL:Double
    var activiteit:String
    var distance:Double?
    
//    init(coder aDecoder: NSCoder) {
//        wat = aDecoder.decodeObject(forKey: "wat") as! String
//        url = aDecoder.decodeObject(forKey: "url") as! String
//        locatienaam = aDecoder.decodeObject(forKey: "locatienaam") as! String
//        straat = aDecoder.decodeObject(forKey: "straat") as! String
//        NB = aDecoder.decodeObject(forKey: "NB") as! Double
//        OL = aDecoder.decodeObject(forKey: "OL") as! Double
//        activiteit = aDecoder.decodeObject(forKey: "activiteit") as! String
//        distance = aDecoder.decodeObject(forKey: "distance") as? Double
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(wat, forKey: "wat")
//        aCoder.encode(url, forKey: "url")
//        aCoder.encode(locatienaam, forKey: "locatienaam")
//        aCoder.encode(straat, forKey: "straat")
//        aCoder.encode(NB, forKey: "NB")
//        aCoder.encode(OL, forKey: "OL")
//        aCoder.encode(activiteit, forKey: "activiteit")
//        aCoder.encode(distance, forKey: "distance")
//    }
}

struct Category:Codable {
    var name:String
    var items:[Item]
}


