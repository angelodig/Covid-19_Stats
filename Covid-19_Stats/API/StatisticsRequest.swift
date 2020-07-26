//
//  CoutriesRequest.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 03/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import Foundation

class StatisticsRequest {
    private let headers: [String : String] = [
        "x-rapidapi-host": "covid-193.p.rapidapi.com",
        "x-rapidapi-key": "a133d6927fmsh03afcde706a5132p1d0ed3jsn3311cb658405"
    ]
    
    func getCountryRequest(completion: @escaping(Result<Countries, Error>) -> Void) {
        let resourceString = "https://covid-193.p.rapidapi.com/countries"
        guard let resourceUrl = URL(string: resourceString) else { fatalError() }
        let url: URL = resourceUrl
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                //let httpResponse = response as? HTTPURLResponse
                //print("Response:", httpResponse!)
                
                do {
                    let decoder = JSONDecoder()
                    let countryResponse = try decoder.decode(Countries.self, from: data!)
                    //print(countryResponse)
                    completion(.success(countryResponse))
                } catch {
                    print("Error response data")
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
    
    func getHistoryRequest(country: String, date: String, completion: @escaping(Result<History, Error>) -> Void) {
        let resourceString = "https://covid-193.p.rapidapi.com/history?day=\(date)&country=\(country)"
        guard let resourceUrl = URL(string: resourceString) else { fatalError() }
        let url: URL = resourceUrl
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                //let httpResponse = response as? HTTPURLResponse
                //print("Response:", httpResponse!)
                
                do {
                    let decoder = JSONDecoder()
                    let historyResponse = try decoder.decode(History.self, from: data!)
                    //print(historyResponse)
                    completion(.success(historyResponse))
                } catch {
                    print("Error response data")
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
    
    func getStatisticsRequest(completion: @escaping(Result<History, Error>) -> Void) {
        let resourceString = "https://covid-193.p.rapidapi.com/statistics"
        guard let resourceUrl = URL(string: resourceString) else { fatalError() }
        let url: URL = resourceUrl
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                //let httpResponse = response as? HTTPURLResponse
                //print("Response:", httpResponse)
                
                do {
                    let decoder = JSONDecoder()
                    let statisticsResponse = try decoder.decode(History.self, from: data!)
                    //print("Statistics response - Statistic request:", statisticsResponse)
                    completion(.success(statisticsResponse))
                } catch {
                    print("Error response data")
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
