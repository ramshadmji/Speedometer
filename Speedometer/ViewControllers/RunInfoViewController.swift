//
//  RunInfoViewController.swift
//  Speedometer
//
//  Created by Mohammed Ramshad K on 18/04/21.
//

import UIKit

class RunInfoViewController: BaseViewController {
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    var arrayKPH: [Double]!
    var Distance: String? = "0.0 km"
    var timer: String? = "00:00:0"
    override func viewDidLoad() {
        super.viewDidLoad()
        if !arrayKPH.isEmpty{
            avgSpeed()
            distanceLabel.text = Distance
            timerLabel.text = timer
        }
        // Do any additional setup after loading the view.
    }
    
    func avgSpeed() {
        let speed:[Double] = arrayKPH
        let speedAvg = speed.reduce(0, +) / Double(speed.count)
        averageSpeedLabel.text = (String(format: "%.0f", speedAvg))
    }
    
    @IBAction func saveInfoAction(_ sender: Any) {
    }
    
    @IBAction func cancelInfoAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
