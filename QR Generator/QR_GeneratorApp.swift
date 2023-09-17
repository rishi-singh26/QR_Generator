//
//  QR_GeneratorApp.swift
//  QR Generator
//
//  Created by Rishi Singh on 17/09/23.
//

import SwiftUI

@main
struct QR_GeneratorApp: App {
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .frame(minWidth: 300, minHeight: 300)
        } label: {
            Image(systemName: "qrcode")
        }
    }
}
