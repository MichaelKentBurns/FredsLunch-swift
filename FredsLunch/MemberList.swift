//
//  MemberList.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//

import Foundation
import CoreData

class MemberList {
    
    var groupName: String?
    var members = [String: Member]()
    var memberNames : [String] = []
    var context: LunchData?
    
    var lunchData : LunchData?
    var bLunchDataIsPresent = false
    
    init( lunchData: LunchData)
    {
        self.lunchData = lunchData
        bLunchDataIsPresent = true
        lunchData.memberList = self
    }
    
    func addMember(member: Member)
    {
        members[member.name!] = member
        memberNames.append(member.name!) 
    }
    
    func getMember(name: String) -> Member?
    {
        let member : Member? = members[name]
        return member
    }
    
}
