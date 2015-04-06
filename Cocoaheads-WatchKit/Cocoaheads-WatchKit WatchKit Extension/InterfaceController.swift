//
//  InterfaceController.swift
//  Cocoaheads-WatchKit WatchKit Extension
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import WatchKit
import Foundation

class MainMenüController: WKInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        WKInterfaceController.openParentApplication([:], reply: { _,_ in
            
        })
    }
    
    @IBAction func addNewElement() {
        
        var vorschläge = ["Wurst", "Käse", "Brot", "Butter", "Marmelade", "Nutella", "Nudeln"]
        
        presentTextInputControllerWithSuggestions(vorschläge, allowedInputMode: .Plain) {
            results in
            
            let newItem = WatchItem()
            newItem.titel = results.first as String
            newItem.datum = NSDate()
            
            Bus.addNewItem(newItem, completion: { success in
                
                if !success {
                    
                }
                
            })
        }
        
    }
    
}

class InterfaceController: WKInterfaceController {

    var items: [WatchItem]!
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Load the items
        Bus.fetchItems({ items in
            self.items = items
            
            self.table.setNumberOfRows(self.items.count, withRowType: "default")
            
            for element in enumerate(items) {
                var row = self.table.rowControllerAtIndex(element.index) as TableRow
                row.item = element.element
            }
        })
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        
        pushControllerWithName("detail", context: items[rowIndex])
        
    }

}

class TableRow: NSObject {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    var item: WatchItem! {
        didSet{
            titleLabel.setText(item.titel)
            var dateF = NSDateFormatter()
            dateF.dateFormat = "hh:MM:ss"
            timeLabel.setText(dateF.stringFromDate(item.datum))
        }
    }
}

class DetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var imageView: WKInterfaceImage!
    @IBOutlet weak var titel: WKInterfaceLabel!
    @IBOutlet weak var datum: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        if let item = context as? WatchItem {
            setTitle(item.titel)
            imageView.setImageNamed("\(item.titel.hash)")
            titel.setText(item.titel)
            
            var dateF = NSDateFormatter()
            dateF.dateFormat = "hh:MM:ss"
            datum.setText(dateF.stringFromDate(item.datum))
            
            var backgroundC = NSKeyedUnarchiver.unarchiveObjectWithData(item.farbe) as? UIColor ?? UIColor.whiteColor()
            
            titel.setTextColor(backgroundC)
        }
    }
    
}