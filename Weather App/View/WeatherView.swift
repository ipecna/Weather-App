//
//  WeatherView.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import UIKit

@objc protocol WeatherViewDelegate  {
    func searchTapped(searchString: String)
    func prepareDetail()
}

class WeatherView: View {
    
    var delegate: WeatherViewDelegate?
    let dataSource = WeatherTableDataSource()
    let emitterLayer = CAEmitterLayer()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.showsCancelButton = true
        bar.tintColor = .black
        bar.searchTextField.textColor = .black
        bar.searchBarStyle = .default
        bar.delegate = self
        return bar
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "CityName"
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        
        label.textColor = .white
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    lazy var conditionButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "globe.europe.africa"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(goToDetail), for: .touchUpInside)
        return button
    }()

    
    lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cityLabel, tempLabel, conditionButton])
        stack.distribution = .equalCentering
        stack.axis = .vertical
        stack.alignment = .center
        stack.contentMode = .scaleAspectFit
        return stack
    }()
    
    lazy var tableView: UITableView =  {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tableView])
        stack.axis = .vertical
        return stack
    }()
    
    override func setViews() {
        super.setViews()
        addSubview(topStack)
        addSubview(bottomStack)
        
        tableView.dataSource = dataSource
    }
    
    override func setLayout() {
        super.setLayout()
        
        topStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 70),
            topStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            topStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            topStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor, constant: -100),
            bottomStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomStack.topAnchor.constraint(equalTo: self.centerYAnchor),
            conditionButton.heightAnchor.constraint(equalToConstant: 70),
            conditionButton.widthAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    func updateWeather(with weather: WeatherModel) {
        cityLabel.text = weather.cityName.uppercased()
        tempLabel.text = weather.temperatureString
        conditionButton.setImage(UIImage(systemName: weather.conditionName), for: .normal)
        topStack.backgroundColor = UIColor(named: weather.temperatureColor)
        bottomStack.backgroundColor = UIColor(named: weather.temperatureColor)
        tableView.backgroundColor = UIColor(named: weather.temperatureColor)
        tableView.backgroundView?.backgroundColor = UIColor(named: weather.temperatureColor)
        backgroundColor = UIColor(named: weather.temperatureColor)
        startAnimation(with: weather)
    }
    
    func startAnimation(with weather: WeatherModel) {
        
        emitterLayer.emitterCells?.removeAll()
        
        switch weather.conditionName {
        case "cloud.drizzle":
            startRaining()
        case "cloud.rain":
            startRaining(heavily: true)
        case "cloud.snow":
            startSnowing()
        case "sun.max":
            startShining()
        case "cloud.fog":
            startFog()
        default :
            startClouds()
        }
    }

    func makeEmitterSnowCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contentsScale = 5.5
        cell.birthRate = 70
        cell.lifetime = 10.0
        cell.lifetimeRange = 2
        cell.color = UIColor.white.cgColor
        cell.alphaRange = 3.2
        cell.velocity = 100
        cell.velocityRange = 150
        cell.emissionLongitude = CGFloat.pi / 2
        cell.yAcceleration = 10
        cell.emissionRange = CGFloat.pi / 2
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05
        cell.contents = UIImage(named: "spark")?.cgImage
        return cell
    }
    
    func makeEmitterRainCell(birthrate: Float) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contentsScale = 10.5
        cell.birthRate = birthrate
        cell.lifetime = 9.0
        cell.lifetimeRange = 2
        cell.color = UIColor(red: 0.57, green: 0.57, blue: 0.57, alpha: 1).cgColor
        cell.alphaRange = 2.2
        cell.velocity = 250
        cell.velocityRange = 150
        cell.emissionLongitude = CGFloat.pi / 2
        cell.yAcceleration = 200
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05
        cell.contents = UIImage(named: "spark")?.cgImage
        return cell
    }
    
    func startRaining(heavily: Bool = false) {
        emitterLayer.emitterPosition = CGPoint(x: frame.midX, y: frame.minY)
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterSize = CGSize(width: frame.size.width, height: 10)
        var birthrate = 50.0
        if heavily {
            birthrate = 250.0
        }
        let rain = makeEmitterRainCell(birthrate: Float(birthrate))
        emitterLayer.emitterCells = [rain]
        self.layer.addSublayer(emitterLayer)
    }
    
    func startShining() {
        
    }
    
    func startSnowing() {
        emitterLayer.emitterPosition = CGPoint(x: frame.midX, y: frame.minY)
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterSize = CGSize(width: frame.size.width, height: 10)
        let snow = makeEmitterSnowCell()
        emitterLayer.emitterCells = [snow]
        self.layer.addSublayer(emitterLayer)
    }
    
    func startFog() {
        
    }
    
    func startClouds() {
        
    }
    
    @objc func goToDetail() {
        delegate?.prepareDetail()
    }
    
}

extension WeatherView : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            self.delegate?.searchTapped(searchString: searchBar.text!)
            searchBar.resignFirstResponder()
            searchBar.text = ""
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
