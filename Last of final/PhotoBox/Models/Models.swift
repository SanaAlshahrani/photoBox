//
//  Models.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 21/04/1443 AH.
//

import Foundation
import UIKit

struct Model {
    let image: String
    let name: String
    let descripe: String
    let name_ar: String
    let descripe_ar: String
    let id: String
    let categoryID: String
    let userID: String


}
struct Video {
    let image: String
    let name: String
    let desc: String
    let vedioUrl: String
}

struct Place {
    let image: String
    let name: String
    let price: String
    let phone: String
}
  
    class ModelCategory: NSObject, Decodable , Encodable{
        let image: String
        let name: String
        let id: String
        let name_ar: String

        init(image: String, name: String, id: String , name_ar : String) {
            self.id = id
            self.name = name
            self.image = image
            self.name_ar = name_ar
        }

        // MARK: - NSCoding
        required init(coder aDecoder: NSCoder) {
            name = aDecoder.decodeObject(forKey: "name") as! String
            id = aDecoder.decodeObject(forKey: "id") as! String
            image = aDecoder.decodeObject(forKey: "image") as! String
            name_ar = aDecoder.decodeObject(forKey: "name_ar") as! String

        }

        func encode(with aCoder: NSCoder) {
            aCoder.encode(id, forKey: "id")
            aCoder.encode(name, forKey: "name")
            aCoder.encode(name, forKey: "name_ar")
            aCoder.encode(name, forKey: "image")

        }
    }
