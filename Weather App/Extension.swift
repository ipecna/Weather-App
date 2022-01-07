//
//  Extension.swift
//  Weather App
//
//  Created by Semyon Chulkov on 02.01.2022.
//

import Foundation


extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date
    }
}

extension Date {

    func toString(withFormat format: String = "EEEE, d MMMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = .current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
