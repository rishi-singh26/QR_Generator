//
//  ContentView.swift
//  QR Generator
//
//  Created by Rishi Singh on 17/09/23.
//

import SwiftUI
import EFQRCode

struct ContentView: View {
    @State private var cgImage: CGImage?
    @State private var isChangingBackgroundColor = true
    
    @AppStorage("bgColorHue") private var bgColorHue = 0.0
    @AppStorage("bgColorBrightness") private var bgColorBrightness = 0.0
    @AppStorage("bgColorOpacity") private var bgColorOpacity = 0.0
    @AppStorage("isBgWhite") private var isBgWhite = true
    
    @AppStorage("fgColorHue") private var fgColorHue = 0.0
    @AppStorage("fgColorBrightness") private var fgColorBrightness = 0.0
    @AppStorage("fgColorOpacity") private var fgColorOpacity = 0.0
    @AppStorage("isFgWhite") private var isFgWhite = false
    
    @AppStorage("qrText") private var qrText: String = ""
    
    var hasImage: Bool {
        if cgImage != nil {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            if hasImage {
                Image(nsImage: NSImage(cgImage: cgImage!, size: NSSize(width: 270, height: 270)))
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .padding()
            }
            
            TextField("Enter text (Press return to generate)", text: $qrText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 272)
                .padding(.bottom, 1)
            
            HStack {
                Text("Download as image")
                Spacer()
                Button {
                    saveImage()
                } label: {
                    Text("Download")
                }
                .buttonStyle(.borderedProminent)
                .help("Save QR code to device")
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
                .padding(.horizontal)
            
            VStack {
                Picker("Which color do you want to switch?", selection: $isChangingBackgroundColor) {
                    Text("Background Color").tag(true)
                    Text("Foreground Color").tag(false)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding(.horizontal)
                
                ColorPickerView(
                    title: isChangingBackgroundColor ? "Background Color" : "Foreground Color",
                    colorHue: isChangingBackgroundColor ? $bgColorHue : $fgColorHue,
                    colorBrightness: isChangingBackgroundColor ? $bgColorBrightness : $fgColorBrightness,
                    colorOpacity: isChangingBackgroundColor ? $bgColorOpacity : $fgColorOpacity,
                    isWhite: isChangingBackgroundColor ? $isBgWhite : $isFgWhite
                ) {
                    generateQRCode()
                }
            }
            
            Divider()
                .padding(.horizontal)
            
            HStack {
                HStack {
                    Text("Quit QR Generator")
                    Text("⌘ Q")
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(role: .destructive) {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text("Quit")
                }
            }
            .padding([.horizontal, .bottom])
        }
        .onAppear(perform: generateQRCode)
        .onSubmit {
            generateQRCode()
        }
        .frame(width: 300)
    }
    
    func generateQRCode() {
        if let image = EFQRCode.generate(
            for: qrText,
            backgroundColor: isBgWhite ? Color.white.cgColor! : Color(hue: bgColorHue, saturation: 1, brightness: bgColorBrightness, opacity: bgColorOpacity).cgColor!,
            foregroundColor: isFgWhite ? Color.white.cgColor! : Color(hue: fgColorHue, saturation: 1, brightness: fgColorBrightness, opacity: fgColorOpacity).cgColor!
        ) {
            cgImage = image
        } else {
            print("Create QRCode image failed!")
        }
    }
    
    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save your image"
        savePanel.message = "Choose a folder and a name to store the image."
        savePanel.nameFieldLabel = "Image file name:"
        
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
    
    func saveImage() {
        if let path = showSavePanel() {
            let image = NSImage(cgImage: cgImage!, size: NSSize(width: 280, height: 280))
            let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
            let pngData = imageRepresentation?.representation (using: .png, properties: [:])
            do {
                try pngData?.write (to: path)
            } catch {
                print (error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
