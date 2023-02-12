//
//  Data.swift
//  Todoey
//
//  Created by saloni on 09/02/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

class Item: Codable {
    // if 'Codable' then all properties must be standard (String, Bool, Int etc)
    var title: String = ""
    var done: Bool = false
}

// ns userDefaults is limited to just dictionary, whereas encoding (codable) allows use of array that can store data reliably. Both can only use standard data types. Notice if we go to our created plist for 'Items', our string and bool data is encoded much like a encoding from a JSON.
