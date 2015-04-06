//
//  ViewController.swift
//  Cocoaheads-WatchKit
//
//  Created by Benjamin Herzog on 06.04.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//
//
// Icons from http://brsev.deviantart.com/art/Mnml-Icon-Set-106367676
//

import UIKit
import CoreData

var icons = ["1-adobe",
    "1-circle",
    "1-desktop",
    "1-office",
    "1-star",
    "1-start",
    "camera",
    "chrome",
    "digsby",
    "down",
    "email",
    "firefox",
    "folder",
    "gmail",
    "ie",
    "illustrator",
    "indesign",
    "maps",
    "music",
    "notes",
    "opera",
    "photoshop",
    "power",
    "preview",
    "recycle",
    "screenshot",
    "slideshow",
    "spreadsheet",
    "task",
    "toolbox",
    "wmp",
    "writing"]

func randomImage() -> UIImage {
    var index = Int(Int(arc4random()) % icons.count)
    return UIImage(named: icons[index] + ".png")!
}

class MainTableViewController: UITableViewController {
    
    var items: [Item] = [Item]()
    var managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.colorWith(65, g: 131, b: 215, a: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        items = fetchItemsFromDB()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default") as DefaultTableViewCell
        cell.item = items[indexPath.row]
        cell.backgroundColor = UIColor.random()
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            managedObjectContext.deleteObject(items[indexPath.row])
            managedObjectContext.save(nil)
            items = fetchItemsFromDB()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Löschen"
    }
    
    func fetchItemsFromDB() -> [Item] {
        var request = NSFetchRequest(entityName: "Item")
        var erg = managedObjectContext.executeFetchRequest(request, error: nil) as [Item]
        erg.sort { $0.titel < $1.titel }
        return erg
    }

    // MARK: - IBActions
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "Neues Item", message: "Bitte geben Sie einen Titel ein.", preferredStyle: .Alert)
        
        var okAction = UIAlertAction(title: "Ok", style: .Default) { action in
            // Speicher neuen Datensatz
            var newItem = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: self.managedObjectContext) as Item
            newItem.titel = (alert.textFields?.first as? UITextField)?.text ?? ""
            newItem.datum = NSDate()
            newItem.image = randomImage()
            self.managedObjectContext.save(nil)
            self.items = self.fetchItemsFromDB()
            self.tableView.reloadData()
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler {
            textField in
            textField.placeholder = "Titel"
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

}

class DefaultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var item: Item? {
        didSet{
            pictureImageView.image = item?.image
            titleLabel.text = item?.titel
            let dateF = NSDateFormatter()
            dateF.dateFormat = "dd.MM.yyyy HH:mm:SS"
            dateLabel.text = dateF.stringFromDate(item?.datum ?? NSDate())
        }
    }
}

extension Item {
    
    var image: UIImage {
        get{
            return UIImage(data: bild) ?? UIImage()
        }
        set{
            bild = UIImagePNGRepresentation(newValue)
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
    
    class func colorWith(r: CGFloat, g: CGFloat, b: CGFloat, a: Int) -> UIColor {
        var redValue = CGFloat(r/255.0)
        var greenValue = CGFloat(g/255.0)
        var blueValue = CGFloat(b/255.0)
        return UIColor(red: CGFloat(redValue), green: CGFloat(greenValue), blue: CGFloat(blueValue), alpha: 1)
    }
}