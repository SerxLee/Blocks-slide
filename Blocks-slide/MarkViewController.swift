//
//  MarkViewController.swift
//  Blocks-slide
//
//  Created by Serx on 3/16/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import UIKit
import CoreData

class MarkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let level: [Int] = [11, 12, 13, 21, 22, 23]
    let game: [String] = ["game11", "game12", "game13", "game21", "game22", "game23"]
    
    var managedContext: NSManagedObjectContext!
    
    var markEntity: NSEntityDescription!
    var markFetch: NSFetchRequest!
    
    var resultOfMark: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        markEntity = NSEntityDescription.entityForName("Mark", inManagedObjectContext: managedContext)
        markFetch = NSFetchRequest(entityName: "Mark")
        
        do{
            let result =
                try managedContext.executeFetchRequest(markFetch) as! [NSDictionary]
            
            if result.count > 0{
                
                resultOfMark = result.first!
            }
        }catch let error as NSError{
            print("Error: \(error) " +
                "description \(error.localizedDescription)")
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        return 2
    }
    
    

    //set the section title for every level
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "level 1"
        }else if section == 1{
                return "level 2"
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier: String = "markCell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        
        
        let keyString: String
        keyString = game[indexPath.section * 3 + indexPath.row]
        
        let mark = resultOfMark[keyString]
        
        cell.textLabel?.text = String(mark)
        
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
