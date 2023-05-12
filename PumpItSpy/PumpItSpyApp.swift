//
//  PumpItSpyApp.swift
//  PumpItSpy
//
//  Created by Philippe on 2023-05-11.
//

import SwiftUI

@main
struct PumpItSpyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
