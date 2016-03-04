//
//  RunsTableViewController.swift
//  Runner
//
//  Created by Jeff Chang on 2016-02-20.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import UIKit
import CoreData

class RunsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var runs = [Run]()
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.rowHeight = 61
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        fetchData()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Run")
        
        do{
            try runs = managedContext.executeFetchRequest(fetchRequest) as! [Run]
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return runs.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let run = runs[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("RunsTableViewCell", forIndexPath: indexPath) as! RunsTableViewCell
        cell.runTime.text = run.time
        cell.runDistance.text = String(roundToPlaces(run.distance, places:2)) + "km"
        cell.runTitle.text = run.runName
        cell.satisfactionImage.bounds = CGRectMake(0, 0, 45, 45)
        cell.satisfactionImage.contentMode = .ScaleAspectFit
        cell.satisfactionImage.image = UIImage(named: run.satisfaction)
        cell.satisfactionImage.center.y = 31.5
        cell.userInteractionEnabled = true
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTableView.deselectRowAtIndexPath(indexPath, animated: true)
//        print("CLICKED")
//        let run = runs[indexPath.row]
//        run.setValue("RUN BRUH RUN", forKey: "runName")
//        do{
//            try run.managedObjectContext?.save()
//        }catch{
//            let saveError = error as NSError
//            print(saveError)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "runSegue"{
            if let destination = segue.destinationViewController as? RunViewController{
                if let runIndex = myTableView.indexPathForSelectedRow?.row{
                    destination.run = runs[runIndex]
                }
            }
        }
        print(myTableView.indexPathForSelectedRow?.row)
        
    }
    
    func roundToPlaces(value:Double, places:Double)->Double{
        let divisor = pow(10.0, Double(places))
        return round(value*divisor)/divisor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        myTableView.reloadData()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
