//
//  FBAApp.swift
//  FBA
//
//  Created by admin on 22/04/24.
//

import SwiftUI
import Firebase

@main
struct FBAApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

