//
//  ViewController.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import UIKit

class ViewController<V: View> : UIViewController {
    
    override func loadView() {
        view = V()
    }
    
    var customView: V {
        return view as! V
    }
}
