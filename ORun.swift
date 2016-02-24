//
//  ORun.swift
//  Runner
//
//  Created by Jeff Chang on 2016-02-23.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import UIKit
import CoreLocation

class ORun: NSObject {
    
    var locations: [CLLocation]?
    var totalTime: Int?
    var formatTime: String?
    var hour:Int?
    var min:Int?
    var sec:Int?
    var distance:Double?
    var averageSpeed:Double?
    
    init(locations: [CLLocation], totalTime: Int, formatTime: String, hour: Int, min: Int, sec: Int, distance: Double, averageSpeed: Double){
        self.locations = locations
        self.totalTime = totalTime
        self.formatTime = formatTime
        self.hour = hour
        self.min = min
        self.sec = sec
        self.distance = distance
        self.averageSpeed = averageSpeed
    }
    
    func getLocations() -> [CLLocation] {
        return locations!;
    }
    
    func gesTotalTime()->Int{
        return totalTime!;
    }
    
    func getFormatTime()->String{
        return formatTime!
    }
    
    func getHour()->Int{
        return hour!
    }
    
    func getMin()->Int{
        return min!
    }
    
    func getSec()->Int{
        return sec!
    }
    
    func getDistance()->Double{
        return distance!
    }
    
    func getAverageSpeed()->Double{
        return averageSpeed!
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
        return returnString
    }
    
}
