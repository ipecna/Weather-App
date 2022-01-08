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
        let config = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .large)
        button.setImage(UIImage(systemName: "globe.europe.africa")?.withConfiguration(config), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(goToDetail), for: .touchUpInside)
        return button
    }()
    
    lazy var detailsButton: UIButton = {
        var button = UIButton()
        button.setTitle("more", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .gray()
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToDetail), for: .touchUpInside)
        return button
    }()

    
    lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cityLabel, tempLabel, conditionButton, detailsButton])
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
            topStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            topStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            topStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            topStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor, constant: -80),
            bottomStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomStack.topAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func updateWeather(with weather: WeatherModel) {
        cityLabel.text = weather.cityName.uppercased()
        tempLabel.text = weather.temperatureString
        let config = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .large)
        conditionButton.setImage(UIImage(systemName: weather.conditionName)?.withConfiguration(config), for: .normal)
        
        topStack.backgroundColor = .clear
        bottomStack.backgroundColor = UIColor(named: weather.temperatureColor)
        tableView.backgroundColor = UIColor(named: weather.temperatureColor)
        tableView.backgroundView?.backgroundColor = UIColor(named: weather.temperatureColor)
        
        backgroundColor = UIColor(named: weather.temperatureColor)
        emitterLayer.emitterCells?.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.startAnimation(with: weather)
        }
    }
    
    func startAnimation(with weather: WeatherModel) {
        
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

    //MARK: - Rain Handling
    
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
        emitterLayer.zPosition = 0
        self.layer.addSublayer(emitterLayer)
    }
    
    //MARK: - Sun Handling
    
    func startShining() {
        emitterLayer.emitterPosition = CGPoint(x: frame.minX, y: frame.minY + 50)
        emitterLayer.emitterShape = .point
        emitterLayer.emitterSize = CGSize(width: 80, height: 80)
        
        let sun = makeEmitterSunCell()
        emitterLayer.emitterCells = [sun]
        emitterLayer.zPosition = -1
        self.layer.addSublayer(emitterLayer)
    }
    
    func makeEmitterSunCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.scale = 2
        cell.birthRate = 25
        cell.lifetime = 5
        cell.scaleRange = 1
        cell.scaleSpeed = 1.5
        cell.color = UIColor(red: 0.97, green: 0.62, blue: 0.12, alpha: 1.00).cgColor
        cell.alphaRange = 0.2
        cell.velocity = 0.09
        cell.yAcceleration = 0
        cell.xAcceleration = 0
        cell.spin = 2
        cell.spinRange = 5
        
        cell.contents = UIImage(named: "spark")?.cgImage
        return cell
    }
    
    //MARK: - Snow Handling
    
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
    
    func startSnowing() {
        emitterLayer.emitterPosition = CGPoint(x: frame.midX, y: frame.minY)
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterSize = CGSize(width: frame.size.width, height: 10)
        let snow = makeEmitterSnowCell()
        emitterLayer.emitterCells = [snow]
        emitterLayer.zPosition = 0
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
