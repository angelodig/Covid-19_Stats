//
//  ViewController.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 01/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {

    @IBOutlet weak var selectCountryBackgroundView: UIView!
    @IBOutlet weak var selectDateBackgroundView: UIView!
    @IBOutlet weak var searchBtnBackgroundView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var rankingBtnBackgroundView: UIView!
    
    @IBOutlet weak var countryChoosenBtn: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var currentSituationBtnBackgroundView: UIView!
    
    private var datePicker: UIDatePicker?
    
    var countryChoosen: String?
    var date: String?
    var currentCountry: String?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
        setUIGraphicDetails()
        setDatePicker()
        
    }
    
    
//MARK: - IBAction
    @IBAction func selectCountryButton_touchUpInside(_ sender: Any) {
        view.endEditing(true) //Hide datepicker
        self.performSegue(withIdentifier: "segueToSelectCountryTVC", sender: nil)
    }
    
    @IBAction func searchBtn_touchUpInside(_ sender: Any) {
        view.endEditing(true) //Hide datepicker
        guard countryChoosen != nil else {
            presentAlert(title: "Select a Country", message: "You have to select a country")
            return
        }
        self.performSegue(withIdentifier: "segueToDetailsViewController", sender: nil)
    }
    
    @IBAction func showRanking_touchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToRankingVC", sender: nil)
    }
    
    @IBAction func currentSituazion_touchUpInside(_ sender: Any) {
        guard self.currentCountry != nil else { return }
        self.performSegue(withIdentifier: "segueToDetailsVCForCurrentLocation", sender: nil)
    }
    
    @IBAction func unwindToSearchViewController(_ segue: UIStoryboardSegue) {
        if let source = segue.source as? SelectCountryTableViewController {
            self.countryChoosen = source.countryChoosen
            countryChoosenBtn.setTitle(countryChoosen, for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "segueToDetailsViewController" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.countryChoosen = countryChoosen
            detailsVC.date = date
        } else if identifier == "segueToDetailsVCForCurrentLocation" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.countryChoosen = self.currentCountry
            //Get current Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = Date()
            date = dateFormatter.string(from: currentDate)
            detailsVC.date = date
        }
    }
    
//MARK: - Set UI Grapichs
    private func setUIGraphicDetails() {
        //Round Corners View
        selectCountryBackgroundView.layer.cornerRadius = 10
        selectDateBackgroundView.layer.cornerRadius = 10
        searchBtnBackgroundView.layer.cornerRadius = 10
        separatorView.layer.cornerRadius = 5
        rankingBtnBackgroundView.layer.cornerRadius = 10
        currentSituationBtnBackgroundView.layer.cornerRadius = 10
    }
    
//MARK: PickerDate Helper
    //  Show Date Picker
    func setDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.maximumDate = NSDate() as Date
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SearchViewController.dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        //Show current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        dateTextField.text = dateFormatter.string(from: currentDate)
        date = dateTextField.text
        
        tapGestureToHidePickerDate()
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        date = dateTextField.text
    }
    
    //  Tap gesture Recognizer to Hide Picker Date
    func tapGestureToHidePickerDate() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
//MARK: Present alert method
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
  
}

//MARK: Location Manager
extension SearchViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { country, error in
            guard let country = country, error == nil else { return }
            print(country)
            
            switch country { ///Manage some mismatch CoreLocation and API Statistics country name
            case "United States":
                self.currentCountry = "USA"
            default:
                self.currentCountry = country
            }
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.country, error)
        }
    }
}
