//
//  DetailWeatherView.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import UIKit

class DetailWeatherView : View {
    
    private lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var populationLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var topStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [cityLabel, populationLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var sunriseLabel: UILabel = {
        var label = UILabel()
        label.text = "Sunrise"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    private lazy var sunriseLabelData: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var sunsetLabel: UILabel = {
        var label = UILabel()
        label.text = "Sunset"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    private lazy var sunsetLabelData: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var sunLeftStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [sunriseLabelData, sunriseLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var sunRightStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [sunsetLabelData, sunsetLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var temperatureLabel: UILabel = {
        var label = UILabel()
        label.text = "Temperature"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    private lazy var temperatureLabelData: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var feelsLikeLabel: UILabel = {
        var label = UILabel()
        label.text = "Feels like"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    private lazy var feelsLikeLabelData: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        var label = UILabel()
        label.text = "Wind"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    private lazy var windLabelData: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var humidityLabel: UILabel = {
        var label = UILabel()
        label.text = "Humidity"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    private lazy var humidityLabelData: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var bottomRightStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [temperatureLabelData, feelsLikeLabelData, windLabelData, humidityLabelData])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var bottomLeftStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [temperatureLabel, feelsLikeLabel, windLabel, humidityLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func setViews() {
        super.setViews()
        
        addSubview(topStack)
        addSubview(bottomLeftStack)
        addSubview(bottomRightStack)
        addSubview(sunLeftStack)
        addSubview(sunRightStack)
    }
    
    override func setLayout() {
        super.setLayout()
        
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            topStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            topStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            topStack.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            sunLeftStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 150),
            sunLeftStack.heightAnchor.constraint(equalToConstant: 60),
            sunLeftStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sunLeftStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: -20),
            
            sunRightStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 150),
            sunRightStack.heightAnchor.constraint(equalToConstant: 60),
            sunRightStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: 20),
            sunRightStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            bottomLeftStack.topAnchor.constraint(equalTo: sunLeftStack.bottomAnchor, constant: 100),
            bottomLeftStack.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomLeftStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bottomLeftStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: -20),
            
            bottomRightStack.topAnchor.constraint(equalTo: sunRightStack.bottomAnchor, constant: 100),
            bottomRightStack.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomRightStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: 20),
            bottomRightStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func updateWeather(with weather: WeatherModel) {
        cityLabel.text = weather.cityName
        populationLabel.text = "Population: \(weather.population) people"
        sunriseLabelData.text = weather.sunriseString
        sunsetLabelData.text = weather.sunsetString
        temperatureLabelData.text = weather.temperatureString
        feelsLikeLabelData.text = weather.feelsLikeString
        windLabelData.text = weather.windString
        humidityLabelData.text = "\(weather.humidity)%"
    }
    
}
