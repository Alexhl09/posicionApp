//
//  ViewController.swift
//  posicionApp
//
//  Created by Alejandro on 04/02/18.
//  Copyright © 2018 Alejandro. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var miMapa: MKMapView!
    var pos = CLLocation()
var camara = MKMapCamera()
    var a :Int = 0
    var zoomDistance: CLLocationDistance = 7000
    private let manejador = CLLocationManager()
    var firstPosition = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manejador.distanceFilter = 50
      
        miMapa.centerCoordinate = CLLocationCoordinate2D.init(latitude: 37, longitude: -122)
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
    
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse
        {
            manejador.startUpdatingLocation()
            miMapa.showsUserLocation = true
            
            
        }
        else
        {
            manejador.stopUpdatingLocation()
             miMapa.showsUserLocation = false
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if a == 0
        {
            pos = CLLocation(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
            a = 1;
        }
        
        firstPosition.latitude = manager.location!.coordinate.latitude
        firstPosition.longitude = manager.location!.coordinate.longitude
        
        camara = MKMapCamera(lookingAtCenter: firstPosition, fromEyeCoordinate: firstPosition, eyeAltitude: zoomDistance)
        
        let firstPositionLo = CLLocation(latitude: firstPosition.latitude, longitude: firstPosition.longitude)
        
        miMapa.setCamera(camara, animated: true)
    
        var distanciaMetros = firstPositionLo.distance(from: pos)
        
        

        if distanciaMetros > 50
        {
            var punto = CLLocationCoordinate2D()
            punto.latitude = manejador.location!.coordinate.latitude
            punto.longitude = manejador.location!.coordinate.longitude
            let pin = MKPointAnnotation()
            pin.title = "\(manejador.location!.coordinate.longitude) , \(manejador.location!.coordinate.latitude)"
            pin.subtitle = "\(distanciaMetros)"
            pin.coordinate = punto
            miMapa.addAnnotation(pin)
           distanciaMetros = 0
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alerta = UIAlertController(title: "Error", message: "error \(error)", preferredStyle: .alert)
        let accionOk = UIAlertAction(title: "Ok", style: .default, handler: {
            accion in
        })
        alerta.addAction(accionOk)
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func control(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            miMapa.mapType = .standard
        case 1:
            miMapa.mapType = .satellite
        default:
            miMapa.mapType = .hybrid
        }
    }
    
    @IBAction func zoomIn(_ sender: UIButton) {
        if camara.altitude >= 1000 && camara.altitude <= 7000 {
            zoomDistance -= 1000.0
        }
    }
    
   
    @IBAction func zoomOut(_ sender: UIButton) {
        if camara.altitude >= 1000 && camara.altitude <= 7000 {
            zoomDistance += 1000.0
        }
    }
    
    
}

