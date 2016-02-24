//
//  PostRunViewController.swift
//  Runner
//
//  Created by Jeff Chang on 2016-02-15.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class PostRunViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    var run:ORun?
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var veryGoodButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myNavBar: UIView!
    @IBOutlet weak var myView:UIView!
    @IBOutlet weak var runNameTV:UITextField!
    
    @IBOutlet weak var map: MKMapView!
    
    var satisfaction: String = "Very Happy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI();
        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height + 150)
        self.runNameTV.delegate = self;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        myView.addGestureRecognizer(tap)
        self.map.delegate = self
        drawMap()
    }
    
    func dismissKeyboard(){
        runNameTV.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.grayColor().CGColor
        border.frame = CGRect(x: 0, y: myNavBar.frame.size.height - width, width:  myNavBar.frame.size.width, height: myNavBar.frame.size.height)
        
        border.borderWidth = width
        myNavBar.layer.addSublayer(border)
        myNavBar.layer.masksToBounds = true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? RunMarker{
            let view:MKPinAnnotationView
            let dequedView = map.dequeueReusableAnnotationViewWithIdentifier(annotation.identifier)
            if(dequedView == nil){
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            }else{
                view = dequedView as! MKPinAnnotationView
            }
            switch annotation.identifier {
                case "start":
                    view.pinTintColor = UIColor.redColor()
                    break
                case "end":
                    view.pinTintColor = UIColor.greenColor()
                    break
                default:
                    break
            }
            return view
        }
        return nil
    }

    func drawMap(){
        // Set the map bounds
        map.region = mapRegion()
        
        // Make the line(s!) on the map
        map.addOverlay(polyline())
        let firstPin: RunMarker = RunMarker(identifier: "start", coordinate: run!.locations!.last!.coordinate)
        map.addAnnotation(firstPin);
        let lastPin: RunMarker = RunMarker(identifier: "end", coordinate: run!.locations!.first!.coordinate)
        map.addAnnotation(lastPin);
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        assert(overlay is MKPolyline, "overlay must be mkpolyline")
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 4;
        
        return polylineRenderer
    }
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        let locations: [CLLocation] = run!.getLocations()
        for location in locations {
            coords.append(location.coordinate)
        }
        
        return MKPolyline(coordinates: &coords, count: locations.count)
    }
    
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc: CLLocation = run!.getLocations().first!
        
        var minLat = initialLoc.coordinate.latitude
        var minLng = initialLoc.coordinate.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = run!.getLocations() 
        
        for location in locations {
            minLat = min(minLat, location.coordinate.latitude)
            minLng = min(minLng, location.coordinate.longitude)
            maxLat = max(maxLat, location.coordinate.latitude)
            maxLng = max(maxLng, location.coordinate.longitude)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                longitudeDelta: (maxLng - minLng)*1.1))
    }
    
    @IBAction func satisfactionButtons(sender:UIButton){
        switch sender.tag{
        case 0:
            veryGoodButton.setBackgroundImage(UIImage(named:"Very Happy Clicked"), forState: .Normal)
            goodButton.setBackgroundImage(UIImage(named:"Good"), forState: .Normal)
            neutralButton.setBackgroundImage(UIImage(named:"Neutral"), forState: .Normal)
            badButton.setBackgroundImage(UIImage(named:"Bad"), forState: .Normal)
            self.satisfaction = "Very Happy"
            break
        case 1:
            veryGoodButton.setBackgroundImage(UIImage(named:"Very Happy"), forState: .Normal)
            goodButton.setBackgroundImage(UIImage(named:"Happy Clicked"), forState: .Normal)
            neutralButton.setBackgroundImage(UIImage(named:"Neutral"), forState: .Normal)
            badButton.setBackgroundImage(UIImage(named:"Bad"), forState: .Normal)
            self.satisfaction = "Good"
            break;
        case 2:
            veryGoodButton.setBackgroundImage(UIImage(named:"Very Happy"), forState: .Normal)
            goodButton.setBackgroundImage(UIImage(named:"Good"), forState: .Normal)
            neutralButton.setBackgroundImage(UIImage(named:"Neutral Clicked"), forState: .Normal)
            badButton.setBackgroundImage(UIImage(named:"Bad"), forState: .Normal)
            self.satisfaction = "Neutral"
            break;
        case 3:
            veryGoodButton.setBackgroundImage(UIImage(named:"Very Happy"), forState: .Normal)
            goodButton.setBackgroundImage(UIImage(named:"Good"), forState: .Normal)
            neutralButton.setBackgroundImage(UIImage(named:"Neutral"), forState: .Normal)
            badButton.setBackgroundImage(UIImage(named:"Sad Clicked"), forState: .Normal)
            self.satisfaction = "Bad"
            break;
        default:
            break
            
        }
    }
    
    func fillUI(){
        timeLabel.text = run!.getFormatTime();
        distanceLabel.text = String(roundToPlaces(run!.getDistance(), places:2)) + "km";
        speedLabel.text = String(roundToPlaces(run!.getAverageSpeed(), places:2)) + "km/h";
    }
    
    
    
    @IBAction func Dismiss(sender: AnyObject) {
        print("fml")
        if(runNameTV.text == ""){
            let alertController = UIAlertController(title:"Your run feels alone!", message: "Please provide a name for your run!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "I feel ashamed.", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion:nil)
        }else{
            storeData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func storeData(){
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Run", inManagedObjectContext: context)
        let runE = Run(entity: entity!, insertIntoManagedObjectContext: context)
        runE.setValue(run!.getLocations(), forKey: "coordinates")
        runE.setValue(run!.getFormatTime(), forKey:"time")
        runE.setValue(run!.getHour(), forKey:"hours")
        runE.setValue(run!.getMin(), forKey: "minutes")
        runE.setValue(run!.getSec(), forKey: "seconds")
        runE.setValue(run!.getDistance(), forKey: "distance")
        runE.setValue(run!.getAverageSpeed(), forKey: "speed")
        runE.setValue(runNameTV.text, forKey: "runName")
        runE.setValue(self.satisfaction, forKey: "satisfaction")
        do{
            try context.save()
            print("Save successful")
        }catch {
            print("Save unsuccessful")
        }
        
    }
    @IBAction func discardRun(sender: UIButton) {
        let alertController: UIAlertController = UIAlertController(title: "Discard Run", message: "Are you sure you wish to dscard your run", preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func roundToPlaces(value:Double, places:Double)->Double{
        let divisor = pow(10.0, Double(places))
        return round(value*divisor)/divisor
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
