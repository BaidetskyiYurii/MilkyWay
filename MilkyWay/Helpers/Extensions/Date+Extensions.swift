//
//  Date+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 26.02.2026.
//

import Foundation

extension Date {
    
    enum DisplayFormat {
        case full               // 25 February 2026, 18:42
        case short              // 25/02/2026, 18:42
        case abbreviated        // Feb 25, 2026 at 6:42 PM
        case dateOnly           // 25/02/2026
        case timeOnly           // 18:42 (or 6:42 PM)
        case custom(day: Bool, month: Bool, year: Bool, time: Bool)
    }
    
    func formatted(_ format: DisplayFormat) -> String {
        switch format {
            
        case .full:
            return self.formatted(
                Date.FormatStyle()
                    .day()
                    .month(.wide)
                    .year()
                    .hour()
                    .minute()
            )
            
        case .short:
            return self.formatted(
                Date.FormatStyle()
                    .day(.twoDigits)
                    .month(.twoDigits)
                    .year()
                    .hour()
                    .minute()
            )
            
        case .abbreviated:
            return self.formatted(
                date: .abbreviated,
                time: .shortened
            )
            
        case .dateOnly:
            return self.formatted(date: .numeric, time: .omitted)
            
        case .timeOnly:
            return self.formatted(date: .omitted, time: .shortened)
            
        case let .custom(day, month, year, time):
            var style = Date.FormatStyle()
            
            if day { style = style.day() }
            if month { style = style.month() }
            if year { style = style.year() }
            if time { style = style.hour().minute() }
            
            return self.formatted(style)
        }
    }
}
