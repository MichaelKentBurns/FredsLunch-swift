//
//  LunchData.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//

import Foundation
import CoreData

class LunchData: NSObject
{
    
    var accountName: String?
    var lunchList: LunchList?
    var memberList: MemberList?
    
    var csv: CSV? = nil
    var url: NSURL? = nil
    var dataURLString : String? = nil
    // lunchList :
    // var memberList: MemberList?
    var debug = true
    let encoding = String.Encoding.utf8
    var postDone = false
    
    var fredsBaseURL =  //"http://localhost:8081/FredsLunch"
    "http://www.fathersWork.org:8081/FredsLunch"
    var fredsAccountName = "fred"
    
    let urlSep = "/"
    var fredsAccountURL : String!
    var fredsDataURL : String!
    
    override init()
    {
        super.init()
        lunchList = LunchList(self)
        memberList = MemberList(lunchData: self)
    }
    
    let dmyFormatter = DateFormatter()
    
    let ymdhmsFormatter = DateFormatter()
    var isSetup = false
    
    func setup( )
    {
        if !isSetup
        {
            dmyFormatter.dateFormat = "dd-MMM-yyyy"
            dmyFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            
            ymdhmsFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            ymdhmsFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        }
    }
    
    func parseDate(text: String) -> Date?
    {
        var date : Date? = ymdhmsFormatter.date(from: text) as Date?
        if date == nil
        {
            date = dmyFormatter.date(from: text)
        }
        return date
    }
    
    func formatDate(date : Date?) -> String
    {
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
        let text = "31-Dec-\(year)" // "\(year)-12-31 23:59:59"
        var date : Date? = ymdhmsFormatter.date(from: text)
        if date == nil
        {
            date = dmyFormatter.date(from: text)
        }
        return date
    }
    
    
}
