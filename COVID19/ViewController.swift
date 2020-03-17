//
//  ViewController.swift
//  COVID19
//
//  Created by Hariharan Murugesan on 17/03/20.
//  Copyright © 2020 Hariharan Murugesan. All rights reserved.
//

import UIKit


class PandemicViewController: UITableViewController {
    
    var count = 0
    var DataFromAPI: CoronaStats?
    
    var cases: [Int] = []
    var deaths: [Int] = []
    var recoveries: [Int] = []
    
    var totalCases = 0
    var totalDeaths =  0
    var totalRecoveries = 0
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var holderView: UIView!
    
    @IBOutlet weak var totalCase: UILabel!
    @IBOutlet weak var totalDeath: UILabel!
    @IBOutlet weak var totalRecovery: UILabel!
    
    
    
    func generateTotalValues() {
        
        totalCase.text = "\(NumberFormatter.localizedString(from: NSNumber(value: totalCases), number: .decimal))"
        totalDeath.text = "\(NumberFormatter.localizedString(from: NSNumber(value: totalDeaths), number: .decimal))"
        totalRecovery.text = "\(NumberFormatter.localizedString(from: NSNumber(value: totalRecoveries), number: .decimal))"
        
        
    }
    
    func CoronaStatusGlobal(){
        
        let headers = [
            "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
            "x-rapidapi-key": apiKey
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-19-coronavirus-statistics.p.rapidapi.com/v1/stats")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error")
            }
                
            else {
                guard let data = data else {return}
                print(String(data: data, encoding: .utf8)!)
                
                do {
                    
                    let parsed = try JSONDecoder().decode(CoronaStats.self, from: data)
                    if parsed.error == false {
                        DispatchQueue.main.async {
                            self.count = parsed.data.covid19Stats.count
                            self.DataFromAPI = parsed
                            
                            for i in 0...parsed.data.covid19Stats.count - 1 {
                                
                                self.cases.append(parsed.data.covid19Stats[i].confirmed ?? 0)
                                self.deaths.append(parsed.data.covid19Stats[i].deaths ?? 0)
                                self.recoveries.append(parsed.data.covid19Stats[i].recovered ?? 0)
                                
                                self.totalCases = self.cases.reduce(0, +)
                                self.totalDeaths = self.deaths.reduce(0, +)
                                self.totalRecoveries = self.recoveries.reduce(0, +)
                                
                            }
                            
                            self.generateTotalValues()
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.removeFromSuperview()
                            
                            self.tableView.reloadData()
                            
                        }
                    }
                        
                    else {
                        
                        print("API Error")
                        
                    }
                    
                }
                    
                catch{
                    print(error)
                }
                
            }
        })
        
        dataTask.resume()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        CoronaStatusGlobal()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CoronaStatusCell
        
        cell.cases.text = "\(NumberFormatter.localizedString(from: NSNumber(value: DataFromAPI?.data.covid19Stats[indexPath.section].confirmed ?? 0), number: .decimal))"
        cell.deaths.text = "\(NumberFormatter.localizedString(from: NSNumber(value: DataFromAPI?.data.covid19Stats[indexPath.section].deaths ?? 0), number: .decimal))"
        cell.recoveries.text = "\(NumberFormatter.localizedString(from: NSNumber(value: DataFromAPI?.data.covid19Stats[indexPath.section].recovered ?? 0), number: .decimal))"
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if DataFromAPI?.data.covid19Stats[section].province == "" {
            return "\(DataFromAPI?.data.covid19Stats[section].country ?? "N.A")"
        }
            
        else {
            return "\(DataFromAPI?.data.covid19Stats[section].province ?? "N/A"), \((DataFromAPI?.data.covid19Stats[section].country ?? "N.A"))"
        }
        
        
    }
    
}
