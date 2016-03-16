//
//  chooseLevelTableViewController.swift
//  Blocks-slide
//
//  Created by Serx on 3/15/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import UIKit
import CoreData


class chooseLevelTableViewController: UITableViewController {
    
    var managerContext: NSManagedObjectContext!
    
    let levelComplexity = ["level 1", "level 2"]
    
    let levelOne = ["game 1-1", "game 1-2", "game 1-3"]
    let levelTwo = ["game 2-1", "game 2-2", "game 2-3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 40.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let sen = (indexPath.section + 1) * 10 + indexPath.row + 1
        performSegueWithIdentifier("levelToGame", sender: sen)
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "levelToGame"{
            let controllerview = segue.destinationViewController as! UINavigationController
            let nextController = controllerview.topViewController as! ViewController
            
            nextController.level = sender as! Int
            nextController.managedContext = managerContext
            NSLog("segue")
        }
    }
    
}
