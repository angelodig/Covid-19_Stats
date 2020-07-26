//
//  ViewController.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 01/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var selectCountryBackgroundView: UIView!
    @IBOutlet weak var selectDateBackgroundView: UIView!
    @IBOutlet weak var searchBtnBackgroundView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var showRankingBackgroundView: UIView!
    
    @IBOutlet weak var countryChoosenBtn: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    var countryChoosen: String?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func unwindToSearchViewController(_ segue: UIStoryboardSegue) {
        if let source = segue.source as? SelectCountryTableViewController {
            self.countryChoosen = source.countryChoosen
            countryChoosenBtn.setTitle(countryChoosen, for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "segueToDetailsViewController" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.countryChoosen = countryChoosen
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
        showRankingBackgroundView.layer.cornerRadius = 10
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

