//
//  asdf.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/06/26.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

extension Date {
    func dateFrom(date:Date) -> NSDateComponents{
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        let components = cal.components(unitFlags, from: date as Date, to: self, options: NSCalendar.Options())
        return components as NSDateComponents
    }
    
    func offset(toDate: Date) -> String{
        let components = self.dateFrom(date: toDate as Date)
        if components.year != 0{
            return "\(components.year)y"
        }else if components.month != 0{
            return "\(components.month)mon"
        }else if components.day != 0{
            return "\(components.day)d"
        }else if components.hour != 0{
            return "\(components.hour)h"
        }else if components.minute != 0{
            return "\(components.minute)m"
        }else if components.second != 0{
            return "\(components.second)s"
        }else{
            return "Just"
        }
    }
}
extension String {
    func postDate() -> Date{
        let date_formatter: DateFormatter = DateFormatter()
        date_formatter.locale     = NSLocale(localeIdentifier: "ja") as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let change_date:Date = date_formatter.date(from: self)! as Date
        return change_date
        
    }
}
