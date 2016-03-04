//
//  RunViewController.swift
//  Runner
//
//  Created by Jeff Chang on 2016-02-26.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import CoreLocation
import Social

class RunViewController: UIViewController, MKMapViewDelegate{
    
    var run: Run?
    
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
    @IBOutlet weak var runName:UINavigationItem!
    
    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height + 240)
        self.map.delegate = self
        drawMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let firstPin: RunMarker = RunMarker(identifier: "start", coordinate: run!.coordinates.last!.coordinate)
        map.addAnnotation(firstPin);
        let lastPin: RunMarker = RunMarker(identifier: "end", coordinate: run!.coordinates.first!.coordinate)
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
        let locations: [CLLocation] = run!.coordinates
        for location in locations {
            coords.append(location.coordinate)
        }
        
        return MKPolyline(coordinates: &coords, count: locations.count)
    }
    
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc: CLLocation = run!.coordinates.first!
        
        var minLat = initialLoc.coordinate.latitude
        var minLng = initialLoc.coordinate.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = run!.coordinates
        
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

    
    func fillUI(){
        timeLabel.text = run!.time;
        distanceLabel.text = String(roundToPlaces(run!.distance, places:2)) + "km";
        speedLabel.text = String(roundToPlaces(run!.speed, places:2)) + "km/h";
        navBar.title = run!.runName
        switch run!.satisfaction{
        case "Very Happy":
            veryGoodButton.setBackgroundImage(UIImage(named:"Very Happy Clicked"), forState: .Normal)
            goodButton.setBackgroundImage(UIImage(named:"Good"), forState: .Normal)
            neutralButton.setBackgroundImage(UIImage(named:"Neutral"), forState: .Normal)
            badButton.setBackgroundImage(UIImage(named:"Bad"), forState: .Normal)
            break
        case "Good":
            veryGoodButton.setBackgroundImage(UIImage(named:"Very Happy"), forState: .Normal)
            goodButton.setBackgroundImage(UIImage(named:"Happy Clicked"), forState: .Normal)
            neutralButton.setBackgroundImage(UIImage(named:"Neutral"), forState: .Normal)
            badButton.setBackgroundImage(UIImage(named:"Bad"), forState: .Normal)
            break;
        case "Neutral":
            veryGoodButton.setBackgroundImage(UIImage(named:"Very Happy"), forState: .Normal)
            goodButton.setBackgroundImage(UIImage(named:"Good"), forState: .Normal)
            neutralButton.setBackgroundImage(UIImage(named:"Neutral Clicked"), forState: .Normal)
            badButton.setBackgroundImage(UIImage(named:"Bad"), forState: .Normal)
            break;
        case "Bad":
            veryGoodButton.setBackgroundImage(UIImage(named:"Very Happy"), forState: .Normal)
            goodButton.setBackgroundImage(UIImage(named:"Good"), forState: .Normal)
            neutralButton.setBackgroundImage(UIImage(named:"Neutral"), forState: .Normal)
            badButton.setBackgroundImage(UIImage(named:"Sad Clicked"), forState: .Normal)
            break;
        default:
            break
        }
    }
    
    @IBAction func deleteRun(sender: AnyObject) {
    }
    
    @IBAction func dismiss(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func roundToPlaces(value:Double, places:Double)->Double{
        let divisor = pow(10.0, Double(places))
        return round(value*divisor)/divisor
    }
    
    @IBAction func shareWithFacebook(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? CompeteViewController{
            destination.run = run
        }

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
