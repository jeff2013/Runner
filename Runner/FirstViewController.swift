//
//  FirstViewController.swift
//  Runner
//
//  Created by Jeff Chang on 2016-02-13.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITabBarControllerDelegate{

    var locationManager = CLLocationManager()
    var myLocations: [CLLocation] = [];
    var speeds: [Double] = [];
    var timer:NSTimer?;
    var lastTime = 0;
    var totalSeconds = 0;
    var isRunning = false;
    var currentPositionPin: MKPointAnnotation?;
    var startLocation: CLLocation?;
    var lastLocation: CLLocation?;
    var distance:Double = 0;
    var tempLocation: CLLocation?;
    
    var hour = 0;
    var min = 0;
    var sec = 0;
    
    var totalTime:String?;
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPositionPin = MKPointAnnotation();
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.delegate = self;
        initializeMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let lat:CLLocationDegrees = userLocation.coordinate.latitude
        let lon:CLLocationDegrees = userLocation.coordinate.longitude
        
        if(isRunning){
            lastTime = totalSeconds;
            myLocations.append(locations[0] as CLLocation)
            if(myLocations.count == 1){
                currentPositionPin!.coordinate = CLLocationCoordinate2DMake(lat, lon)
                mapView.addAnnotation(currentPositionPin!);
                startLocation = locations[0]
                lastLocation = locations[0];
            }
            if(myLocations.count>1){
                let destIndex = myLocations.count-1
                let sourceIndex = myLocations.count-2
                let c1 = myLocations[sourceIndex]
                let c2 = myLocations[destIndex]
                lastLocation = c2;
                var lineDiffCoor = [c2.coordinate, c1.coordinate]
                
                //drawPolyline(c1, destination: c2);
                let polyline = MKPolyline(coordinates: &lineDiffCoor, count: lineDiffCoor.count)
                mapView.addOverlay(polyline)
                let lastDistance = Double(round(1000*c1.distanceFromLocation(c2))/1000);
                distance += lastDistance;
                storeSpeed(lastDistance);
                lastLocation = c1;
                
            }
        }else{
            //currentPositionPin!.coordinate = CLLocationCoordinate2DMake(lat, lon)
            //mapView.addAnnotation(currentPositionPin!);
        }
        setMap(lat, longitude: lon);
        
        //updateTime();
        //print(userLocation);
    }
    
    func drawPolyline(source: CLLocation, destination: CLLocation){
        let request = MKDirectionsRequest()
        var loc: CLLocationCoordinate2D?
        if(tempLocation == nil){
            loc = source.coordinate;
        }else{
            loc = tempLocation?.coordinate
            tempLocation = nil;
        }
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: loc!, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false;
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else {
                print("ELSE CASE")
                if (self.tempLocation == nil){
                    self.tempLocation = source;
                }
                return
            }
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
            }
        }
    }
    
    func initializeMap(){
        let latitude:CLLocationDegrees = 49.287179
        let longitude:CLLocationDegrees = -123.126759
        let latDelta:CLLocationDegrees = 0.5
        let longDelta:CLLocationDegrees = 0.5
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.showsUserLocation = true;
        mapView.setRegion(region, animated: true)
    }
    
    func setMap(latitude:CLLocationDegrees, longitude: CLLocationDegrees){
        let latitude:CLLocationDegrees = latitude
        let longitude:CLLocationDegrees = longitude
        let latDelta:CLLocationDegrees = 0.0
        let longDelta:CLLocationDegrees = 0.0
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true);
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        assert(overlay is MKPolyline, "overlay must be mkpolyline")
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 4;

        return polylineRenderer
    }
    
    func storeSpeed(lastDistance: Double){
        //stores speed as km/h. Original data given in m/s
        //if user is currently moving then the location is updated per second, same as our timer; thus m/s is original unit. Otherwise it took x amount of 
        //time to travel y distance. E.g: 400m/32s
        speeds.append((3.6*lastDistance)/(totalSeconds-lastTime == 0 ? 1.0: Double(totalSeconds-lastTime)));
    }
    
    func averageSpeed() -> Double{
        var averageSpeed = 0.0;
        for speed in speeds{
            //print(speed);
            averageSpeed += speed
        }
        return averageSpeed/Double(speeds.count);
    }
    
    @IBAction func stopTracking(sender: AnyObject) {
        locationManager.stopUpdatingLocation();
        isRunning = false;
        timer?.invalidate();
        lastTime = 0;
        totalSeconds = 0;
        timeLabel.text = "00:00:00"
        gatherInformation();
    }

    @IBAction func startTracking(sender: AnyObject) {
        startTimer();
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        isRunning = true;
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("View did appear")
        mapView.removeAnnotations(mapView.annotations)
        locationManager.startUpdatingLocation()
    }
    
    func centerMapOn(location: CLLocationCoordinate2D){
        mapView.setCenterCoordinate(location, animated: true);
    }
    
    func gatherInformation(){
    }
    
    func resetMap(){
        myLocations = [];
        timeLabel.text = "00:00:00"
        mapView.removeOverlays(mapView.overlays)
    }
    
    func startTimer(){
        hour = 0;
        min = 0;
        sec = 0;
    }
    
    func updateTime(){
        totalSeconds++;
        if(sec == 59){
            sec = 0;
            if(min == 59){
                min = 0;
                hour++;
            }else{
                min++
            }
        }else{
            sec++;
        }
        timeLabel.text = generateFormatTime()
    }
    
    func generateFormatTime()->String{
        var returnString = "";
        if(hour < 10){
            returnString = returnString + "0" + String(hour);
        }else{
            returnString = returnString + String(hour);
        }
        returnString += ":";
        
        if(min < 10){
            returnString = returnString + "0" + String(min);
        }else{
            returnString = returnString + String(min);
        }
        returnString += ":";
        if(sec < 10){
            returnString = returnString + "0" + String(sec);
        }else{
            returnString = returnString + String(sec);
        }
        totalTime = returnString;
        return returnString
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "postRun"){
            let viewController:PostRunViewController = segue.destinationViewController as! PostRunViewController
            var run: ORun = ORun(locations: myLocations, totalTime: totalSeconds, formatTime: totalTime!, hour: hour, min: min, sec: sec, distance: distance/Double(1000), averageSpeed: averageSpeed())
            viewController.run = run;
            resetMap()
        }
    }
    
    func min(one: Double, two: Double)-> Double{
        return one<two ? one : two;
    }
    
    func max(one:Double, two:Double)->Double{
        return one>two ? one : two;
    }
    
    func roundToPlaces(value:Double, places:Double)->Double{
        let divisor = pow(10.0, Double(places))
        return round(value*divisor)/divisor
    }
    

}

	