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
    @State private var isBgHintShowing: Bool = false
    @State private var isFgHintShowing: Bool = false
    
    @AppStorage("qrText") private var qrText: String = ""
    @AppStorage("bgHexCode") private var bgHexCode: String = "#FFFFFF"
    @AppStorage("fgHexCode") private var fgHexCode: String = "#000000"
    
    // MARK: - Advanced color variables
    @State private var isUsingAdvancedColors = true
    @State private var isChangingBackgroundColor = true
    
    @AppStorage("bgColorHue") private var bgColorHue = 0.0
    @AppStorage("bgColorBrightness") private var bgColorBrightness = 0.0
    @AppStorage("bgColorOpacity") private var bgColorOpacity = 0.0
    @AppStorage("isBgWhite") private var isBgWhite = true
    
    @AppStorage("fgColorHue") private var fgColorHue = 0.0
    @AppStorage("fgColorBrightness") private var fgColorBrightness = 0.0
    @AppStorage("fgColorOpacity") private var fgColorOpacity = 1.0
    @AppStorage("isFgWhite") private var isFgWhite = false
    
    var hasImage: Bool {
        if cgImage != nil {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            if hasImage {
                VStack {
                    Image(nsImage: NSImage(cgImage: cgImage!, size: NSSize(width: 270, height: 270)))
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .padding()
                        .contextMenu {
                            Button {
                                print("Copy Image")
                                copyImageToClipBoard()
                            } label: {
                                Label("Copy Image", systemImage: "location.circle")
                            }
                        }
                }
                .frame(width: 300, height: 300)
            }
            
            TextField("Enter text (Press return to generate)", text: $qrText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 272)
                .padding(.bottom, 1)
            
            HStack {
                Text("Export")
                Spacer()
                Button {
                    copyImageToClipBoard()
                } label: {
                    Text("Copy")
                }
                .buttonStyle(.borderedProminent)
                .help("Copy QR code to clipboard")
                Button {
                    saveImage()
                } label: {
                    Text("Save")
                }
                .buttonStyle(.borderedProminent)
                .help("Save QR code to device")
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
                .padding(.horizontal)
            
//            Toggle("Advanced Colors", isOn: $isUsingAdvancedColors)
//                .onChange(of: isUsingAdvancedColors) { _ in
//                    generateQRCode()
//                }
            if !isUsingAdvancedColors {
                VStack {
                    HexColorInputView(isHintShowing: $isBgHintShowing, textBoxValue: $bgHexCode, title: "Background color")
                    HexColorInputView(isHintShowing: $isFgHintShowing, textBoxValue: $fgHexCode, title: "Foreground color")
                }
                .padding(.horizontal)
            }
            
            if isUsingAdvancedColors {
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
//            backgroundColor: (Color(hex: bgHexCode) ?? .white).cgColor!,
//            foregroundColor: (Color(hex: fgHexCode) ?? .black).cgColor!
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
            guard let pngData = createPNG(cgImage: cgImage!) else { return }
            do {
                try pngData.write (to: path)
            } catch {
                print (error)
            }
        }
    }
    
    func createPNG(cgImage: CGImage) -> Data? {
        let image = NSImage(cgImage: cgImage, size: NSSize(width: 280, height: 280))
        let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
        return imageRepresentation?.representation (using: .png, properties: [:])
    }
    
    func copyImageToClipBoard() {
        let image = NSImage(cgImage: cgImage!, size: NSSize(width: 270, height: 270))
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.writeObjects([image])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
