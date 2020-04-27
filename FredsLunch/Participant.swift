//
//  Participant.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//

import Foundation
import CoreData

class Participant
{

    var amountEaten = 0.0
    var amountPaid = 0.0
    var comments: String = ""
    var didEat: Bool = true
    var didPay: Bool = false
    var eventId: String = ""
    var eventName: String = ""
    var id: String  = ""
    var role: String = "eater"
    var when: Date = Date()
    var member: Member
    var lunch: Lunch

    init(member: Member, lunch: Lunch, amountEaten: Double, amountPaid: Double )
    {
        self.member = member
        id = member.name!
        self.lunch = lunch
        self.when = lunch.date
        
        lunch.eaterBalance += amountEaten
        
        if amountPaid > 0.0
        {
            didPay = true
            self.amountPaid = amountPaid
            self.role = "payer"
            lunch.payerName = member.name
        }
        else if amountEaten > 0
        {
            didPay = false
            self.role = "eater"
            self.amountEaten = amountEaten
        }
        
        
        
    }
    
    func paid(amountPaid: Double)
    {
        role = "payer"
        didPay = true
        self.amountPaid = amountPaid
        lunch.payerName = member.name!
    }
    
    func ate(amountEaten: Double )
    {
        didEat = true
        self.amountEaten = amountEaten
    }
}

