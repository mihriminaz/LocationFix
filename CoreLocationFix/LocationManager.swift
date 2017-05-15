//
//  LocationManager.swift
//  CoreLocationFix
//
//  Created by mihriban minaz on 24.04.17.
//  Copyright © 2017 mihriban minaz. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
  static let locationStatusChangedNotification = "LocationStatusChanged"
  var locationManager: CLLocationManager!
  var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined
  static let sharedInstance = LocationManager()

  private override init () {
    locationManager = CLLocationManager()

    super.init()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()

  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    locationAuthorizationStatus = status
    NotificationCenter.default.post(name: Notification.Name(rawValue: LocationManager.locationStatusChangedNotification), object: nil)
    debugPrint(locationAuthorizationStatus.rawValue)
    switch locationAuthorizationStatus {
    case .authorizedAlways:
      debugPrint("authorizedAlways")
    case .authorizedWhenInUse:
      debugPrint("authorizedWhenInUse")
    case .denied: // tell to change the settings for the application
      debugPrint("denied")
    case .notDetermined: // tell to change the settings for location on/off
      debugPrint("notDetermined")
    case .restricted: // What is this?
      debugPrint("restricted")
    }

    /*case notDetermined
     case restricted
     case denied


     // User has granted authorization to use their location at any time,
     // including monitoring for regions, visits, or significant location changes.
     //
     // This value should be used on iOS, tvOS and watchOS.  It is available on
     // MacOS, but kCLAuthorizationStatusAuthorized is synonymous and preferred.
     @available(iOS 8.0, *)
     case authorizedAlways


     // User has granted authorization to use their location only when your app
     // is visible to them (it will be made visible to them if you continue to
     // receive location updates while in the background).  Authorization to use
     // launch APIs has not been granted.
     //
     // This value is not available on MacOS.  It should be used on iOS, tvOS and
     // watchOS.
     @available(iOS 8.0, *)
     case authorizedWhenInUse
     */
  }

  func showAlert(message: String,  actionTitle: String, actionCallback: @escaping (UIAlertAction) -> ()) {

    let alertController = UIAlertController(title: "Location Unknown", message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: actionCallback)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(alertAction)
    alertController.addAction(cancelAction)

    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
  }


  func useLocationInfo() {

    switch locationAuthorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        if CLLocationManager.isRangingAvailable() {
          debugPrint("You can use the location info now.")
        }
      }

    case .denied: // tell to change the settings for the application
      if CLLocationManager.locationServicesEnabled() {
        goToApplicationLocationSettings()
      }
      else {
        goToGeneralLocationSettings()
      }
    case .notDetermined: // tell to change the settings for location on/off
      goToGeneralLocationSettings()
    case .restricted: // What is this?
      goToGeneralLocationSettings()
    }
  }

  func goToGeneralLocationSettings() {
    let alertMessage = "Your device's location is not enabled, please turn it on."
    let actionTitle = "Location Settings"
    showAlert(message:alertMessage, actionTitle: actionTitle, actionCallback: { action in
      if let url = URL(string:"App-Prefs:root=Privacy&path=LOCATION") {
        UIApplication.shared.open(url, completionHandler: { couldOpen in
          let message = couldOpen ? "App-Prefs:root=Privacy&path=LOCATION URL could open" : "App-Prefs:root=Privacy&path=LOCATION URL could NOT open"
          debugPrint(message)
        })
      }
    })
  }

  func goToApplicationLocationSettings() {
    let alertMessage = "The application is not allowed to use device's location. Please change permissions."
    let actionTitle = "Application Settings"
    showAlert(message: alertMessage, actionTitle: actionTitle, actionCallback: { action in
      self.openSettingsURLString()
    })
  }

  func openSettingsURLString() {
    if let url = URL(string:UIApplicationOpenSettingsURLString) {
      UIApplication.shared.open(url, completionHandler: { couldOpen in
        let message = couldOpen ? "UIApplicationOpenSettingsURLString could open" : "UIApplicationOpenSettingsURLString could NOT open"
        debugPrint(message)
      })
    }
  }
  
}
