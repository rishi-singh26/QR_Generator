//
//  QR_GeneratorApp.swift
//  QR Generator
//
//  Created by Rishi Singh on 17/09/23.
//

import SwiftUI

@main
struct QR_GeneratorApp: App {
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Image(systemName: "qrcode")
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
    func updateActivationPolicy(to policy: NSApplication.ActivationPolicy) {
            NSApp.setActivationPolicy(policy)
            NSApp.activate(ignoringOtherApps: true)
    }
}
