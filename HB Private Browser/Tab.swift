//
//  Tab.swift
//  HB Private Browser
//
//  Created by Benjamin Prentiss on 6/11/23.
//

import SwiftUI

struct Tab {
    var currentURL: String? = nil
    var navigationHistory: [(URL, Bool)] = [] // (URL, isBackNavigation) pairs
    var currentIndex: Int? = nil // Index in navigationHistory of current URL
}

