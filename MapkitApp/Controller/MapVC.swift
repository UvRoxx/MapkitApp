//
//  MapVC.swift
//  MapkitApp
//
//  Created by UTKARSH VARMA on 2021-02-07.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    //MARK:Model Objects
    let saveLoadData = SaveLoadData()
    
    //MARK:Setting Up Outlets and Mehtod Objects
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeDescription: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    //MARK:Data Model 
    var savedLocations = [SavedLocations]()
    //MARK:Map Vars
    var uilgr = UILongPressGestureRecognizer(target: self, action: #selector(recognizeLongPress(_ :)))
    var locationTitle = ""
    var locationInfo  = ""
    var lat = 0.0
    var lng = 0.0
    var savedAnnotation:String?{
        didSet{
            restoreAnnotation()
        }
    }
    
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        //MARK:Setting Up Delegate Methods
        placeName.delegate = self
        placeDescription.delegate = self
        map.delegate = self
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(recognizeLongPress(_:)))
        map.addGestureRecognizer(myLongPress)
        
        
        
    }
    
    func restoreAnnotation(){
        saveLoadData.loadInfo { (error, saveData) in
            if let e = error{
                print(e)
            }else{
                savedLocations = saveData!
            }
            for location in savedLocations{
                if location.locationName == savedAnnotation{
                    let pin = MKPointAnnotation()
                    pin.coordinate.latitude = location.locationLat
                    pin.coordinate.longitude = location.locationLng
                    pin.title = location.locationName
                    pin.subtitle = location.locationInfo
                    DispatchQueue.main.async {
                        self.map.addAnnotation(pin)
                        
                        
                    }
                }
                
            }
        }
        
    }
    @objc private func recognizeLongPress(_ sender:UILongPressGestureRecognizer){
        //Checking for unintentional longpress
        print("called")
        if sender.state != UIGestureRecognizer.State.began{
            return
        }
        
        
        let location = sender.location(in: map)
        let coordinates:CLLocationCoordinate2D = map.convert(location, toCoordinateFrom: map)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        if let title = placeName.text{
            locationTitle = title
        }
        if let info = placeDescription.text{
            locationInfo = info
        }
        pin.title = locationTitle
        pin.subtitle = locationInfo
        map.addAnnotation(pin)
        
    }
    
    
    @IBAction func saveInfo(_ sender: UIButton) {
        var alert = UIAlertController()
        if let locName = placeName.text, let locInfo = placeDescription.text{
            if let error = saveLoadData.saveInfo(name: locName, info: locInfo, lat: lat, lng: lng){
                alert = saveLoadData.saveLoadAlert(alerttitle: "Error", alertMessage:error, alertButtonTitle: "Done")
            }else{
                
                self.savedAnnotation = nil
                alert = saveLoadData.saveLoadAlert(alerttitle:"Save Success", alertMessage: "Location and Info Saved Successfully", alertButtonTitle: "Done")
                self.navigationController?.popViewController(animated: true)
            }
            present(alert, animated: true, completion: nil)

            
        }
        
        
        
    }
    
}

extension MapVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension MapVC:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let myPinIdentifier = "PinAnnotationIdentifier"
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
        myPinView.animatesDrop = true
        myPinView.canShowCallout = true
        myPinView.annotation = annotation
        print("latitude: \(annotation.coordinate.latitude), longitude: \(annotation.coordinate.longitude)")
        lat = annotation.coordinate.latitude
        lng = annotation.coordinate.longitude
        return myPinView
    }
    
}


