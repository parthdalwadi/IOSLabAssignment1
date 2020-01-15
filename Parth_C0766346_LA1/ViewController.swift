//
//  ViewController.swift
//  Parth_C0766346_LA1
//
//  Created by Parth Dalwadi on 2020-01-14.
//  Copyright © 2020 Parth Dalwadi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mymapview: MKMapView!
    @IBOutlet weak var route_type_btn: UIButton!
    
    var isAuto = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mymapview.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        route_type_btn.isHidden = true
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.65, longitude: -79.38), span: span)
        mymapview.setRegion(region, animated: true)
        
        
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addPin))
        doubleTap.numberOfTapsRequired = 2
        mymapview.addGestureRecognizer(doubleTap)
        
        
    }

    
    @objc func addPin(gesture: UIGestureRecognizer){
        
        let allAn = mymapview.annotations
        
        
        if allAn.count > 1{
        let annToRemove = allAn[1]
            
        mymapview.removeAnnotation(annToRemove)
        
        }
        
        let allOverlays = mymapview.overlays
        
        if !allOverlays.isEmpty{
            
            mymapview.removeOverlays(allOverlays)
        }
        isAuto = true
        route_type_btn.isHidden = true
        let touchP = gesture.location(in: mymapview)
        let place = mymapview.convert(touchP, toCoordinateFrom: mymapview)
        
        let pin = MKPointAnnotation()
        pin.coordinate = place
        mymapview.addAnnotation(pin)
        
    }
    
    
    
    @IBAction func findMyWay(_ sender: UIButton) {
        isAuto = true
        route_type_btn.isHidden = false
        let places = mymapview.annotations
        
        if places.count > 1{
        routeShow(source: places[0].coordinate, destination: places[1].coordinate)
        }
    }
    
    
    
    @IBAction func zoomIN(_ sender: Any) {
        
        var curr_r = mymapview.region
        curr_r.span.latitudeDelta = curr_r.span.latitudeDelta/2.0
        curr_r.span.longitudeDelta = curr_r.span.longitudeDelta/2.0
        mymapview.setRegion(curr_r, animated: true)
        
    }
    
    @IBAction func ZoomOUT(_ sender: Any) {
        var curr_r = mymapview.region
        curr_r.span.latitudeDelta = curr_r.span.latitudeDelta*2.0
        curr_r.span.longitudeDelta = curr_r.span.longitudeDelta*2.0
        mymapview.setRegion(curr_r, animated: true)
        
    }
    
    @IBAction func walking_automobile(_ sender: UIButton) {
        
        
       
        
        isAuto = !isAuto
        
        let places = mymapview.annotations
        if places.count > 1{
        routeShow(source: places[0].coordinate, destination: places[1].coordinate)
        }
        
        
        
    }
    
    
    func routeShow(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        
        
    let allOverlays = mymapview.overlays
           
           if !allOverlays.isEmpty{
               
               mymapview.removeOverlays(allOverlays)
           }
    let s_pm = MKPlacemark(coordinate: source)
    let d_pm = MKPlacemark(coordinate: destination)
    
    let dir_req = MKDirections.Request()
    dir_req.source = MKMapItem(placemark: s_pm)
    dir_req.destination = MKMapItem(placemark: d_pm)
        
    
    dir_req.transportType = isAuto ? MKDirectionsTransportType.automobile : MKDirectionsTransportType.walking
    
        let title = isAuto ? "Show Walking Directions" : "Show Driving Directions"
        
        route_type_btn.setTitle(title, for: .normal)
        
    let directions = MKDirections(request: dir_req)
    directions.calculate { (res, e) in
        guard let dir_responce = res else{
            if let er = e{
        
                print("sorry ! we have an error !!")
            }
            return
        }
        let route = dir_responce.routes[0] // fastest route
        self.mymapview.addOverlay(route.polyline, level: .aboveRoads)
        
        
        
        }
    
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        if overlay is MKPolyline{
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        
        
        return renderer
    }
        
        return MKOverlayRenderer()
}
}
