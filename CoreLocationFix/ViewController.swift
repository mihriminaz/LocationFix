//
//  ViewController.swift
//  CoreLocationFix
//
//  Created by mihriban minaz on 24.04.17.
//  Copyright © 2017 mihriban minaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var locationInfoLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: Notification.Name(rawValue: LocationManager.locationStatusChangedNotification), object: nil)
    let _ = LocationManager.sharedInstance
  }

  func locationChanged() {
    debugPrint("LocationManager.sharedInstance.locationAuthorizationStatus changed: ", LocationManager.sharedInstance.locationAuthorizationStatus.rawValue)
    switch LocationManager.sharedInstance.locationAuthorizationStatus {
    case .authorizedAlways:
    locationInfoLabel.text = "authorizedAlways"
    case .authorizedWhenInUse:
      locationInfoLabel.text = "authorizedWhenInUse"
    case .denied:
      locationInfoLabel.text = "denied"
    case .notDetermined:
      locationInfoLabel.text = "notDetermined"
    case .restricted:
      locationInfoLabel.text = "restricted"
    }
  }

  @IBAction func buttonTapped(_ sender: Any) {
    LocationManager.sharedInstance.useLocationInfo()
  }

}

