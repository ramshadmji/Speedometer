//
//  NewRunViewController.swift
//  Speedometer
//
//  Created by Mohammed Ramshad K on 15/04/21.
//

import UIKit
import MapKit
import CoreLocation

class NewRunViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var runTableView: UITableView!
    @IBOutlet weak var resumeOrPause: UIButton!
    
    var timer: Timer = Timer()
    var count: Int = 0
    var timerCounting: Bool = true
    var locationManager: CLLocationManager = CLLocationManager()
    var switchSpeed = "KPH"
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    var arrayMPH: [Double]! = []
    var arrayKPH: [Double]! = []
    var isTimerRunning = true
    var timerValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        runTableView.delegate = self
        //        runTableView.dataSource = self
        //        runTableView.estimatedRowHeight = UITableView.automaticDimension
        //        runTableView.register(UINib.init(nibName: "RunTableViewCell", bundle: nil), forCellReuseIdentifier: "RunTableViewCell")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func timerCounter(){
        count += 1
        let time = secondsToHourMinutSecond(seconds: count)
        let timeString = makeTimeString(hours: time.0, minuits: time.1, seconds: time.2)
        timerLabel.text = timeString
        timerValue = timeString
    }
    
    func secondsToHourMinutSecond(seconds: Int) -> (Int, Int, Int) {
        return ((seconds/3600), ((seconds%3600)/60), ((seconds%3600)%60) )
    }
    
    func makeTimeString(hours: Int, minuits: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "0%2d", hours)
        timeString += ":"
        timeString += String(format: "0%2d", minuits)
        timeString += ":"
        timeString += String(format: "0%2d", seconds)
        return timeString
    }
    
    // 1 mile = 5280 feet
    // Meter to miles = m * 0.00062137
    // 1 meter = 3.28084 feet
    // 1 foot = 0.3048 meters
    // km = m / 1000
    // m = km * 1000
    // ft = m / 3.28084
    // 1 mdile = 1609 meters
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if (location!.horizontalAccuracy > 0) {
            updateLocationInfo(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, speed: location!.speed, direction: location!.course)
        }
        if lastLocation != nil {
            traveledDistance += lastLocation.distance(from: locations.last!)
            if traveledDistance < 1609 {
                let tdMeter = traveledDistance
                distanceLabel.text = (String(format: "%.0f Meters", tdMeter))
            } else if traveledDistance > 1609 {
                let tdKm = traveledDistance / 1000
                distanceLabel.text = (String(format: "%.1f Km", tdKm))
            }
        }
    }
    
    func updateLocationInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees, speed: CLLocationSpeed, direction: CLLocationDirection) {
        let speedToKPH = (speed * 3.6)
        let val = ((direction / 22.5) + 0.5);
        var arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
        let dir = arr[Int(val.truncatingRemainder(dividingBy: 16))]
        if (speedToKPH > 0) {
            averageSpeedLabel.text = (String(format: "%.0f km/h", speedToKPH))
            arrayKPH.append(speedToKPH)
        } else {
            averageSpeedLabel.text = "0 km/h"
        }
    }
    
    @IBAction func stopAction(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RunInfoViewController") as! RunInfoViewController
        if let distance = distanceLabel.text{
            vc.Distance = distance
        }else{
            vc.distanceLabel.text = "0 km/h"
        }
        vc.arrayKPH = arrayKPH
        vc.timer = timerValue
        
        self.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        //navigateTo(vc: "RunInfoViewController")
    }
    
    @IBAction func resumeAction(_ sender: Any) {
        if isTimerRunning{
            resumeOrPause.setTitle("RESUME", for: .normal)
            isTimerRunning = false
            timer.invalidate()
        }else{
            resumeOrPause.setTitle("PAUSE", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            isTimerRunning = true
            
        }
        locationManager.startUpdatingLocation()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
