//
//  DetailsViewController.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 08/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var titleCountryName: UINavigationItem!
    @IBOutlet weak var casesBackgroundView: UIView!
    @IBOutlet weak var deathsBackgroundView: UIView!
    
    @IBOutlet weak var newCasesCountLbl: UILabel!
    @IBOutlet weak var activeCasesCountLbl: UILabel!
    @IBOutlet weak var recoveredCasesCountLbl: UILabel!
    @IBOutlet weak var totalCasesCountLbl: UILabel!
    
    @IBOutlet weak var newDeathsCountLbl: UILabel!
    @IBOutlet weak var totalDeathsCountLbl: UILabel!
    
    @IBOutlet weak var newsBackgroundStackView: UIStackView!
    @IBOutlet weak var titleNewsLbl: UILabel!
    @IBOutlet weak var summaryNewsLbl: UILabel!
    @IBOutlet weak var cleanUrlNewsLbl: UILabel!
    @IBOutlet weak var urlNewsLbl: UIButton!
    
    var countryChoosen: String?
    var date: String?
    var countryCurrentLocation: CLLocation? //TODO: not updated
    var historyResponse: History?
    var newsResponse: News?
    
    //Test
    var italyTestLocation = CLLocation(latitude: 42.76319020, longitude: 12.25152220)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGraphicsDetails()
        showSpinnerView(viewForShowSpinner: newsBackgroundStackView)
        getNewsAndUpdateLbl()
        getHistoryAndUpdateLbl()
        setupMapView()
    }
    
    //MARK: - IBAction
    @IBAction func urlNews_touchUpInside(_ sender: Any) {
        guard let linkNews = newsResponse?.articles.first?.link else { return }
        UIApplication.shared.open(URL(string: linkNews)!, options: [:], completionHandler: nil)
    }
    
    //MARK: - Set details
    private func setGraphicsDetails() {
        casesBackgroundView.layer.cornerRadius = 10
        deathsBackgroundView.layer.cornerRadius = 10
    }
    
    //Set Statistics
    private func getHistoryAndUpdateLbl() {
        let getHistory = StatisticsRequest()
        getHistory.getHistoryRequest(country: countryChoosen!, date: date!) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let historyResponse):
                //print("History response:", historyResponse)
                let historyResponse = History.init(response: historyResponse.response)
                self?.historyResponse = historyResponse
                DispatchQueue.main.async {
                    self!.updateStatisticsLbl()
                }
            }
        }
    }
    
    private func updateStatisticsLbl() {
        self.titleCountryName.title = flag(country: locale(for: self.countryChoosen!)) + self.countryChoosen!
        self.newCasesCountLbl.text = self.historyResponse!.response?.first?.cases.new ?? "No data"
        
        if let n = self.historyResponse!.response?.first?.cases.active {
            self.activeCasesCountLbl.text = "\(n)"
        } else {
            self.activeCasesCountLbl.text = "No Data"
        }
        
        if let n = self.historyResponse!.response?.first?.cases.recovered {
            self.recoveredCasesCountLbl.text = "\(n)"
        } else {
            self.recoveredCasesCountLbl.text = "No Data"
        }
        
        if let n = self.historyResponse!.response?.first?.cases.total {
            self.totalCasesCountLbl.text = "\(n)"
        } else {
            self.totalCasesCountLbl.text = "No Data"
        }
        
        self.newDeathsCountLbl.text = self.historyResponse!.response?.first?.deaths.new ?? "No data"
        
        if let n = self.historyResponse!.response?.first?.deaths.total {
            self.totalDeathsCountLbl.text = "\(n)"
        } else {
            self.totalDeathsCountLbl.text = "No Data"
        }
    }
    
    //Get and show News
    private func getNewsAndUpdateLbl() {
        let getNews = NewsRequest()
        getNews.getNewsCovidRequest(countryISO: locale(for: self.countryChoosen!)) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self!.updateNewsLbl()
                }
            case .success(let newsResponse):
                //print("News Response:", newsResponse)
                let newsResponse = News.init(articles: newsResponse.articles)
                self?.newsResponse = newsResponse
                DispatchQueue.main.async {
                    self!.updateNewsLbl()
                }
            }
        }
    }
    
    private func updateNewsLbl() {
        self.titleNewsLbl.text = self.newsResponse?.articles.first?.title ?? "No News Available"
        self.summaryNewsLbl.text = self.newsResponse?.articles.first?.summary
        self.cleanUrlNewsLbl.text = self.newsResponse?.articles.first?.clean_url
        self.urlNewsLbl.setTitle(self.newsResponse?.articles.first?.link, for: .normal)
    }
    
    //MARK: - Flag country methods
    //Get country flag
    private func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    //Find country in NSLocale from full name
    private func locale(for fullCountryName : String) -> String {
        let locales: String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale.init(localeIdentifier: "en_US")
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                //print("Country LocalCode:", localeCode)
                return localeCode
            }
        }
        //print("Country LocalCode:", localeCode)
        return locales
    }
}

extension DetailsViewController: MKMapViewDelegate {
    private func setupMapView() {
//        var italyTestLocation = CLLocation(latitude: 42.76319020, longitude: 12.25152220)//CLLocation(latitude: 37.334722, longitude: -122.008889)
        if self.countryChoosen != nil {
            fetchCountryLocation(from: self.countryChoosen!) { (location, error) in
                guard let location = location, error == nil else { return }
                print("location:", location)
                //self.italyTestLocation = location
                self.countryCurrentLocation = location
                print("self.countryCurrentLocation:", self.countryCurrentLocation!)
            }
        }
        
        let regionRadius: CLLocationDistance = 1000000
        let region = MKCoordinateRegion(center: self.countryCurrentLocation?.coordinate ?? italyTestLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius) //TODO: Resolve this bug: self.countryCurrentLocation?.coordinate not updated
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
    }
    
    func fetchCountryLocation(from countryName: String, completion: @escaping (_ countryLocation:  CLLocation?, _ error: Error?) -> ()) {
        CLGeocoder().geocodeAddressString(countryName) { placemarks, error in
            completion(placemarks?.first?.location, error)
        }
    }
    
}

