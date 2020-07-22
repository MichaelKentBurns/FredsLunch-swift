//
//  FredsLunchDate.swift
//  FredsLunch
//
//  Created by MichaelBurns on 7/18/20.
//  Copyright © 2020 MichaelBurns. All rights reserved.
//

import Foundation

class FredsLunchDate: NSObject
{
    
    let dmyFormatter = DateFormatter()
    
    let ymdhmsFormatter = DateFormatter()
    var isSetup = false
    
    func setup()
    {
        print("FredsLunchDate.setup() starting ")

        if !isSetup
        {
            dmyFormatter.dateFormat = "dd-MMM-yyyy"
            dmyFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            
            ymdhmsFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            ymdhmsFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            
            test()
        }
        
        print("FredsLunchDate.setup() finished. ")

        
    }
    
    
    func test()
    {
        print("FredsLunchDate.test() starting ")
        //########## private date related
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = 1980;
        dateComponents.month = 7
        dateComponents.day = 11
        dateComponents.timeZone = TimeZone(abbreviation: "CST") // Central Standard Time
        dateComponents.hour = 8
        dateComponents.minute = 34

        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let userCalendarDate = userCalendar.date(from: dateComponents)

        let today : Date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd-MMM-yyyy"
        let dateText = formatter.string(from: today)
        print(" today is \(today) or \(dateText)")

        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        //dateComponents.year
        //dateComponents.month
        //dateComponents.day
        //dateComponents.hour
        //dateComponents.minute
        //dateComponents.second


        //: ## Creating dates from components
        //let newDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents2)
        var currentDate = Calendar.current.date(from: dateComponents)

        formatter.timeStyle = .none
        let hoyDia = formatter.date(from: dateText)
        print( "recreated date value=\(String(describing: hoyDia))")

        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        /* 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time) */
        let string = "1996-12-19T16:39:57-08:00"
        var aWhileAgo = RFC3339DateFormatter.date(from: string)
        print( "date from string \(string) yields date \(aWhileAgo)" )

        print("FredsLunchDate.test() finished. ")

    }
    

        let appDateFormat = "dd-MM-yyyy"
        
        func parseDate(text: String) -> Date?
        {

            if !isSetup { setup() }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = appDateFormat
            let date = dateFormatter.date(from: text)
            
    //        var date : Date? = ymdhmsFormatter.date(from: text) as Date?
    //        if date == nil
    //        {
    //            date = dmyFormatter.date(from: text)
    //        }
            return date
        }
        
        func formatDate(date : Date?) -> String
        {
            
            if !isSetup { setup() }

            if ( date == nil )
            {
                return ""
            }
            else
            {
                return ymdhmsFormatter.string(from: date!)
            }
        }
        
        func lastDayOfYear(year: String) -> Date?
        {
            if !isSetup { setup() }
            
            let text = "31-Dec-\(year)" // "\(year)-12-31 23:59:59"
            var date : Date? = ymdhmsFormatter.date(from: text)
            if date == nil
            {
                date = dmyFormatter.date(from: text)
            }
            return date
        }
}
