//
//  HomeViewController.swift
//  Speedometer
//
//  Created by Mohammed Ramshad K on 14/04/21.
//

import Foundation
import UIKit
class HomeViewController: BaseViewController {
    @IBOutlet weak var startButtonAction: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func startButtonAction(_ sender: Any) {
        navigateTo(vc: "NewRunViewController")
    }
}
