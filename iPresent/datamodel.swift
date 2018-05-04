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
}

struct Category:Codable {
    var name:String
    var items:[Item]
}


