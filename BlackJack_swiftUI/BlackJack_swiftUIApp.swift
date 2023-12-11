//
//  BlackJack_swiftUIApp.swift
//  BlackJack_swiftUI
//
//  Created by Haruko Okada on 10/29/23.
//

import SwiftUI

@main
struct BlackJack_swiftUIApp: App {
    @StateObject var network = Network()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}
