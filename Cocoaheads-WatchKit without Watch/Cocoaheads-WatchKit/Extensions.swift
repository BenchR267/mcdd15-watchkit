//
//  Extensions.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import UIKit
import CoreData

// Extension because Item.swift is managed by CoreData
extension Item {
    
    var image: UIImage {
        get{
            return UIImage(data: bild) ?? UIImage()
        }
        set{
            bild = UIImagePNGRepresentation(newValue)
        }
    }
    
    var color: UIColor {
        get{
            return NSKeyedUnarchiver.unarchiveObjectWithData(farbe) as? UIColor ?? UIColor.blackColor()
        }
        set{
            farbe = NSKeyedArchiver.archivedDataWithRootObject(newValue)
        }
    }
}

extension UIColor {
    
    class func random() -> UIColor {
        let redValue = Float(rand() % 255) / 255
        let greenValue = Float(rand() % 255) / 255
        let blueValue = Float(rand() % 255) / 255
        return UIColor(red: CGFloat(redValue), green: CGFloat(greenValue), blue: CGFloat(blueValue), alpha: 1)
    }
    
}