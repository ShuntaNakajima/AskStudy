//
//  asdf.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/06/26.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

extension NSDate {
    func dateFrom(date:NSDate) -> NSDateComponents{
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second]
        let components = cal.components(unitFlags, fromDate: date, toDate: self, options: NSCalendarOptions())
        return components
    }
    
    func offset(toDate: NSDate) -> String{
        let components = self.dateFrom(toDate)
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
