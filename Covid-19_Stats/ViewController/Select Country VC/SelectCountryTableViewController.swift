//
//  SelectCountryTableViewController.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 01/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import UIKit

class SelectCountryTableViewController: UITableViewController {
    
    var countriesDict = [String : [String]]()
    var countrySectionTitles = [String]()
    var allCountries = Countries.init(response: [String]()) {
        didSet {
            DispatchQueue.main.async {
                //To index countries list
                for country in self.allCountries.response {
                        let countryKey: String = String(country.prefix(1))
                    if var countryValues = self.countriesDict[countryKey] {
                            countryValues.append(country)
                        self.countriesDict[countryKey] = countryValues
                        } else {
                        self.countriesDict[countryKey] = [country]
                        }
                    }

                self.countrySectionTitles = [String](self.countriesDict.keys)
                self.countrySectionTitles = self.countrySectionTitles.sorted(by: { $0 < $1 })
                //print("countriesDict:", self.countriesDict)
                //print("countrySectionTitles", self.countrySectionTitles)
                self.tableView.reloadData()
            }
        }
    }
    
    var countryChoosen: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        showSpinnerView(viewForShowSpinner: tableView)
        getCountries()
        
    }

    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countrySectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countryKey = countrySectionTitles[section]
        if let countryValues = countriesDict[countryKey] {
            return countryValues.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! SelectCountryTableViewCell
        let countryKey = countrySectionTitles[indexPath.section]
        if let countryValues = countriesDict[countryKey] {
            cell.country = countryValues[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countrySectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return countrySectionTitles
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryKey = countrySectionTitles[indexPath.section]
        if let countryValues = countriesDict[countryKey] {
            countryChoosen = countryValues[indexPath.row]
        }
        self.performSegue(withIdentifier: "unwindToSearchViewController", sender: nil)
    }
   
    //MARK: Get Countries Request
    private func getCountries() {
        let countryRequest = StatisticsRequest.init()
        countryRequest.getCountryRequest { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let countries):
                self?.allCountries.response = countries.response
                //print("country list:", self!.allCountries.response.count, self!.allCountries)
            }
        }
    }
}
