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
    @IBOutlet weak var longitud: UILabel!
    @IBOutlet weak var latitud: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var miMapa: MKMapView!
var a = Double()
    private let manejador = CLLocationManager()
    var firstPosition = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manejador.distanceFilter = 50
      
        miMapa.centerCoordinate = CLLocationCoordinate2D.init(latitude: 37, longitude: -122)
      
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        firstPosition = CLLocation(latitude: 37, longitude: -122)
      
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
        
        var location = locations.last as! CLLocation
        let distanceInMeters = location.distance(from: firstPosition)
         distancia.text = "\(distanceInMeters)"

        if distanceInMeters > 50
        {
            var punto = CLLocationCoordinate2D()
            punto.latitude = manejador.location!.coordinate.latitude
            punto.longitude = manejador.location!.coordinate.longitude
            let pin = MKPointAnnotation()
            pin.title = "\(manejador.location!.coordinate.longitude) , \(manejador.location!.coordinate.latitude)"
            pin.subtitle = ""
            pin.coordinate = punto
            miMapa.addAnnotation(pin)
            firstPosition = location
        }
        longitud.text = "\(manejador.location!.coordinate.longitude)"
        latitud.text = "\(manejador.location!.coordinate.latitude)"
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
    
}

