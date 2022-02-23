//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/24/21.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    
    private let service = Service()
    
    private var forecast: Forecast?
    
    private var city: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.isHidden = true
        errorView.delegate = self
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Did Appear")
        
        errorView.isHidden = true
        loadForecastData(for: city)
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: "ForecastCell", bundle: nil),
            forCellReuseIdentifier: "ForecastCell"
        )
        tableView.register(
            UINib(nibName: "ForecastHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "ForecastHeader"
        )
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.sectionFooterHeight = 0.0
    }
    
    func loadForecastData(for city: String){
        DispatchQueue.main.async {
            self.loader.startAnimating()
            self.tableView.isHidden = true
        }
        service.get5DayForecast(for: city, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.forecast = Forecast(resp: response)
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
    //                    print(self.forecast)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorView.handleError(error: error)
                    self.errorView.isHidden = false
                    print(error)
                }
            }
        })
    }
    
    func setCity(city: String){
        self.city = city
    }
    
    @IBAction func refresh(){
        loadForecastData(for: city)
    }


}

extension TableViewController: ErrorViewDelegate {
    func errorViewDelegateDidClickReload() {
        errorView.isHidden = true
        loadForecastData(for: city)
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast?.forecast[section].weekForecast.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecast?.forecast.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        if let forecastCell = cell as? ForecastCell {
            forecastCell.configure(with: (forecast?.forecast[indexPath.section].weekForecast[indexPath.row])!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ForecastHeader")
        if let forecastHeader = header as? ForecastHeader {
            forecastHeader.configure(with: (forecast?.forecast[section].day)!)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
 }



