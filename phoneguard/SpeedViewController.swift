//
//  SpeedViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/8/18.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//


import UIKit
import CoreLocation

class SpeedViewController: UIViewController , CLLocationManagerDelegate {
    
  
    @IBOutlet weak var mpsTextField: UITextField!
    @IBOutlet weak var kphTextField: UITextField!
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - CLLocationManager delegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last,
            CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
                self.mpsTextField.text = "Error"
                self.kphTextField.text = "Error"
                return
        }
        var speed = newLocation.speed
        if(speed < 0 ){
            speed = 0
        }
        self.mpsTextField.text = "".appendingFormat("%.2f", speed)
        self.kphTextField.text = "".appendingFormat("%.2f", speed * 3.6)
    }
}
