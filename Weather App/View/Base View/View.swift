//
//  View.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import UIKit


class View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setViews()
        setLayout()
    }
    
    func setViews() {
        backgroundColor = .white
        //translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setLayout() {
        
    }
}
