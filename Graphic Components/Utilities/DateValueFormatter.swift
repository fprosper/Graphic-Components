//
//  DateValueFormatter.swift
//  Graphic Components
//
//  Created by Fabrizio Prosperi on 27/09/22.
//

import Foundation
import Charts

class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    private var startDate = Date()
    
    init(startDate: Date) {
        self.startDate = startDate
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        dateFormatter.dateFormat = "d/M"
        let date = startDate.addingTimeInterval(value * 3600 * 24)
        print(date)
        let str = dateFormatter.string(from: date)
        print("\(value)  -> \(str)")
        return str
    }
}
