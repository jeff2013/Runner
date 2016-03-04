//
//  CompeteViewController.swift
//  Runner
//
//  Created by Jeff Chang on 2016-03-03.
//  Copyright © 2016 Jeff Chang. All rights reserved.
//

import UIKit

class CompeteViewController: UIViewController {
    
    var run: Run?
    var timer: NSTimer?
    var count = 0.0;

    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var innerCircleProgressView: CircleProgressInner!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        progressView.hideProgressView()
    }
    
    
    func update() {
        count++
        progressView.draw(count/10.0)
        innerCircleProgressView.draw(count/10.0)
    }

    @IBAction func animate(sender: AnyObject) {
        print("Animate called")
        if timer != nil{
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
        }else{
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
        }
        
        //progressView.animateProgressView()
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
