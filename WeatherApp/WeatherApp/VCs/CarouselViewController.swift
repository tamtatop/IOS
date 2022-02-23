//
//  carouselViewController.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/28/21.
//

import UIKit
import UPCarouselFlowLayout
import CoreLocation

//protocol  CarouselViewControllerErrorDelegate {
//    func CarouselViewControllerErrorDelegate(sending error: Error)
//}

class CarouselViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var pageControll: UIPageControl!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    
    private let service = Service()
    
    private let group = DispatchGroup()
    
    private let locationProvider = LocationProvider()
    private var location: CLLocation?
    
    private var weather = [Weather?]()
    private var cityOrder = Dictionary<String, Int>()
    private var myAlert: AlertViewController?
    
    private var currentLocation: CLLocation?
    
    private var currentError: Error?
        
    lazy var carouselLayout: UPCarouselFlowLayout = {
        let carouselLayout = UPCarouselFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        return carouselLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationProvider.enableBasicLocationServices()
        errorView.delegate = self
        tabBarController?.delegate = self
        errorView.isHidden = true
        setupCollectionView()
        setupUserDefaults()
        loadAllWeather()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
        setupLayout()
    }
    
    
    func setupUserDefaults(){
        hideElements(true)
        if let cities = UserDefaults.standard.array(forKey: "cities") as? [String] {
            var i = 0
            for city in cities {
                cityOrder[city] = i
                weather.append(nil)
                i += 1
            }
        } else {
            UserDefaults.standard.set([String](), forKey: "cities")
        }
    }
    
    func loadAllWeather(){
        let cities = UserDefaults.standard.array(forKey: "cities") as? [String]
        for city in cities! {
            loadWeatherData(forOld: city)
        }
        loadWeatherDataForCurrentLocation()
        notifyWeatherDataLoad()
    }
    
    func setupLayout() {
        carouselLayout.itemSize = CGSize(
            width: view.bounds.width * 0.7,
            height: view.bounds.height * 0.7 * 0.9
        )
        carouselLayout.spacingMode = .fixed(spacing: 10)
        carouselLayout.sideItemScale = 0.9
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.collectionViewLayout = carouselLayout
        
        
        collectionView.register(
            UINib(nibName: "WeatherCell", bundle: nil),
            forCellWithReuseIdentifier: "WeatherCell"
        )
        
        collectionView.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPressGesture(gesture:))
            )
        )
    }
    
    @objc
    func handleLongPressGesture(gesture: UILongPressGestureRecognizer){
    
        let location = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location){
            if collectionView.cellForItem(at: indexPath) != nil{
                if gesture.state == .began {
                    deleteItem(at: indexPath)
                    collectionView.reloadData()
                }
            }
        }
    }
    
    func deleteItem(at indexPath: IndexPath){
        
        // don't remove current location weather
        var item = indexPath.row
        if location != nil {
            if item == 0 {
                return
            }
            item -= 1
        }
        
        // remove from UserDefaults
        let alert = UIAlertController(title: "Are you sure you want to delete this item?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[unowned self] _ in
            var cities = UserDefaults.standard.array(forKey: "cities") as? [String]
//            print("ITEM TO REMOVE: ", indexPath.row)
            
            cities?.remove(at: item)
            UserDefaults.standard.removeObject(forKey: "cities")
            UserDefaults.standard.setValue(cities, forKey: "cities")
            
            //remove from weather
            weather.remove(at: indexPath.row)
            
            //rewrite indexing in cityOrder
            for (city, order) in cityOrder {
                if order > indexPath.row {
                    cityOrder[city] = order-1
                }
            }
            collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
        self.present(alert, animated: true)
    }
    
    func loadWeatherData(forNewlyAdded city: String){
        service.getCurrentWeather(for: city, completion: { [weak self] result in
           guard let self = self else { return }
           switch result {
           case .success(let response):
//                print(self.weather)
                let loadedWeather = Weather(resp: response)
                DispatchQueue.main.async {
                    var cities = UserDefaults.standard.array(forKey: "cities") as? [String]
                    if !(cities?.contains(loadedWeather.location.city))! {
                        cities!.append(loadedWeather.location.city)
                        self.cityOrder[loadedWeather.location.city] = self.weather.count
                        self.weather.append(loadedWeather)
                        UserDefaults.standard.removeObject(forKey: "cities")
                        UserDefaults.standard.setValue(cities, forKey: "cities")
                        if let alert = self.myAlert {
                            alert.dismiss()
                        }
                        print(city, " done")
                        self.collectionView.reloadData()
                    } else {
                        if let alert = self.myAlert {
                            alert.handleError(error: ClassError.cityAlreadyAdded)
                        }
                    }
                }
           case .failure(let error):
                if let alert = self.myAlert {
                    alert.handleError(error: error)
                }
           }
//           print(result)
       })
    }
    
    func loadWeatherData(forOld city: String){
        let orderInCollection = (self.cityOrder[city])!
        group.enter()
        service.getCurrentWeather(for: city, completion: { [weak self] result in
           guard let self = self else { return }
           switch result {
           case .success(let response):
//                print(self.weather)
                self.weather[orderInCollection] = Weather(resp: response)
                self.group.leave()
           case .failure(let error):
                DispatchQueue.main.async {
                    print(error, ": error done")
                    self.currentError = error
                    self.group.leave()
                }
           }
       })
    }
    
    func loadWeatherDataForCurrentLocation(){
        group.enter()
        locationProvider.getLocation(completion: { location in
            if let location = location {
                self.service.getCurrentWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude, completion: {[weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        let curWeather = Weather(resp: response)
                        if self.location == nil {
                            self.weather.insert(curWeather, at: 0)
                            for (city, order) in self.cityOrder {
                                self.cityOrder[city] = order+1
                            }
                            self.cityOrder[curWeather.location.city] = 0
                        } else {
                            self.weather[0] = curWeather
                        }
                        print(curWeather.location.city, " done location")
                        self.group.leave()
                        self.location = location
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print(error, ": error done location")
                            self.currentError = error
                            self.group.leave()
                        }
                    }
                })
            } else {
                if self.location != nil {
                    for (city, order) in self.cityOrder {
                        self.cityOrder[city] = order-1
                        if order == -1 {
                            self.cityOrder.removeValue(forKey: city)
                        }
                    }
                    self.weather.remove(at: 0)
                }
                self.location = nil
                self.group.leave()
            }
        })
    }
    
    func notifyWeatherDataLoad(){
        group.notify(queue: .main) {
            self.collectionView.dataSource = self
            print("NOTIFY")
            if let error = self.currentError {
                self.loader.stopAnimating()
                self.errorView.handleError(error: error)
                self.errorView.isHidden = false
                self.currentError = nil
                return
            }
            self.hideElements(false)
            self.collectionView.reloadData()
//            print("SHOULD SHOW RELOADED DATAAAAAAAAAAAAA")
        }
    }
    
    private func hideElements(_ bool: Bool) {
        pageControll.isHidden = bool
        collectionView.isHidden = bool
        addButton.isHidden = bool
        if bool { loader.startAnimating() }
        else { loader.stopAnimating() }
    }
    
    @IBAction func addAlertView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alert = storyboard.instantiateViewController(withIdentifier: "AlertViewController")
        if let myAlert = alert as? AlertViewController {
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.myAlert = myAlert
            self.myAlert?.delegate = self
            self.present(self.myAlert!, animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshData(){
        hideElements(true)
        loadAllWeather()
    }
    
}

extension CarouselViewController: AlertViewControllerDelegate {
    func AlertViewControllerdidClickAddButton(with city: String){
        if city == "" {
            myAlert?.handleError(error: ClassError.emptyString)
            return
        }
        let cities = UserDefaults.standard.array(forKey: "cities") as? [String]
        if !(cities?.contains(city))! {
            loadWeatherData(forNewlyAdded: city)
        } else {
            myAlert?.handleError(error: ClassError.cityAlreadyAdded)
        }
    }
    
    
}

extension CarouselViewController: ErrorViewDelegate {
    func errorViewDelegateDidClickReload() {
        errorView.isHidden = true
        loader.startAnimating()
        loadAllWeather()
    }
    
    
}

extension CarouselViewController: UICollectionViewDelegate {
    
}

extension CarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("COUUUUUUUUUUUUUUUUUUUNNNNNNNNNNNTTTTTTT", weather.count)
        pageControll.numberOfPages = weather.count
        pageControll.isHidden = !(weather.count > 1)
        return weather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
        if let weatherCell = cell as? WeatherCell {
//            print("ROOOOOOOOOOOOOOOOOOOOOOOWWWWW: ", indexPath.row)
//            print(weather)
            if let weatherForRow = weather[indexPath.row] {
                weatherCell.configure(with: weatherForRow, order: indexPath.row)
            }
        }
        return cell
    }
    
    
}

extension CarouselViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageSide = carouselLayout.itemSize.width + carouselLayout.minimumLineSpacing
        let offset = scrollView.contentOffset.x
        pageControll.currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}

extension CarouselViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        print("CURRR PAGE: ", pageControll.currentPage)
        if weather.count == 0 {
            errorView.handleError(error: ClassError.noCity)
            return false
        }
        if (weather[pageControll.currentPage]?.location.city) != nil {
            return true
        }
        errorView.handleError(error: ClassError.noCity)
        return false
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print(viewController)
        if let curCity = weather[pageControll.currentPage]?.location.city {
//            print("CITYYYYYYYYYYYYYYYYYYYYYYYYYYYYY: ", curCity)
            if let navBarVC = viewController as? NavBarViewController{
                if let tableVC = navBarVC.children[0] as? TableViewController {
                    tableVC.setCity(city: curCity)
                }
            }
        }
    }
}

enum ClassError: String, Error {
    case cityAlreadyAdded = "This city's weather is already displayed"
    case emptyString = "City field is empty, please enter a city"
    case noCity = "Couldn't find a city to display its weather"
}
