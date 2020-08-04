//
//  main.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//
// comment added from newly cloned FredsLunch-swift
// comment added in Tifig


import SwiftUI
import CoreData

var debug = true
// setup the hub of the data model and the list for group members
var lunchMain = FredsLunchMain(name: "main")
   // lunchMain.debug = debug
    for arg in CommandLine.arguments
    {
        print(arg)
    }
    lunchMain.arguments = CommandLine.arguments
    lunchMain.run()
