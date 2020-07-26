//
//  RankingViewController.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 25/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var casesBtnLabel: UIButton!
    @IBOutlet weak var deathsBtnLabel: UIButton!
    
    var allStatisticsDaily = History.init(response: [CasesAndDeaths]()) {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        showSpinnerView(viewForShowSpinner: tableView)
        getStatistics()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStatisticsDaily.response!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryRankCell", for: indexPath) as! RankingCountryTableViewCell
        cell.countryLbl.text = "\(indexPath.row + 1) - " + (allStatisticsDaily.response?[indexPath.row].country)!
        cell.casesCounterLbl.text = allStatisticsDaily.response?[indexPath.row].cases.new
        cell.deathsCounterLbl.text = allStatisticsDaily.response?[indexPath.row].deaths.new
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    //MARK: - ACTION
    @IBAction func sortByNewCases_touchUpInside(_ sender: Any) {
        casesBtnLabel.setTitleColor(.red, for: .normal)
        deathsBtnLabel.setTitleColor(.link, for: .normal)
        sortStatisticsByNewCases()
        tableView.reloadData()
    }
    
    @IBAction func sortByNewDeaths_touchUpInside(_ sender: Any) {
        deathsBtnLabel.setTitleColor(.red, for: .normal)
        casesBtnLabel.setTitleColor(.link, for: .normal)
        sortStatisticsByNewDeaths()
        tableView.reloadData()
    }
    
    //MARK: - Get Statistics Request
    private func getStatistics() {
        let statisticsRequest = StatisticsRequest.init()
        statisticsRequest.getStatisticsRequest { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let statistics):
                self?.allStatisticsDaily.response = statistics.response
                //print("Statiscitcs Response:", statistics.response)
                //print("allStatisticsDaily.response:", self?.allStatisticsDaily.response as Any)
                self!.sortStatisticsByNewCases()
            }
        }
    }
    
    //MARK: Sort Statistics
    private func sortStatisticsByNewCases() {
        self.allStatisticsDaily.response = self.allStatisticsDaily.response?.sorted(by: { Int($0.cases.new ?? "0") ?? 0 > Int($1.cases.new ?? "0") ?? 0 })
        print("allStatisticsDaily.response - SORTED by new cases:", self.allStatisticsDaily.response as Any)
        //Remove some results
        let resultsToRemove = ["All", "North-America", "Asia", "South-America", "Europe", "Diamond-Princess-", "Cura&ccedil;ao", "Diamond-Princess", "MS-Zaandam"]
        for r in resultsToRemove {
            if let index = allStatisticsDaily.response?.firstIndex(where: { $0.country == r }) {
                allStatisticsDaily.response?.remove(at: index)
            }
        }
    }
    
    private func sortStatisticsByNewDeaths() {
        self.allStatisticsDaily.response = self.allStatisticsDaily.response?.sorted(by: { Int($0.deaths.new ?? "0") ?? 0 > Int($1.deaths.new ?? "0") ?? 0 })
        print("allStatisticsDaily.response - SORTED by new deaths:", self.allStatisticsDaily.response as Any)
    }
}
