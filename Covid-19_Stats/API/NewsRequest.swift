//
//  NewsRequest.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 25/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import Foundation

class NewsRequest {
   private let headers = [
        "x-rapidapi-host": "covid-19-news.p.rapidapi.com",
        "x-rapidapi-key": "a133d6927fmsh03afcde706a5132p1d0ed3jsn3311cb658405"
    ]
    
    func getNewsCovidRequest(countryISO: String, numberOfResults: String = "1", completion: @escaping(Result<News, Error>) -> Void) {
        let resourceString = "https://covid-19-news.p.rapidapi.com/v1/covid?lang=en&page_size=\(numberOfResults)&media=False&country=\(countryISO)&q=covid" //"https://covid-19-news.p.rapidapi.com/v1/covid?lang=en&media=True&q=covid"
        guard let resourceUrl = URL(string: resourceString) else { fatalError() }
        let url: URL = resourceUrl
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                //let httpResponse = response as? HTTPURLResponse
                //print("Response:", httpResponse!)
                
                do {
                    let decoder = JSONDecoder()
                    let newsResponse = try decoder.decode(News.self, from: data!)
                    //print(newsResponse)
                    completion(.success(newsResponse))
                } catch {
                    print("Error response data")
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
