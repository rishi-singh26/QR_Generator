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
    @AppStorage("qrText") private var qrText: String = ""
    
    var hasImage: Bool {
        if cgImage != nil {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            TextField("Enter text (Press enter to generate)", text: $qrText)
                .padding([.horizontal, .top])
            if hasImage {
                Image(nsImage: NSImage(cgImage: cgImage!, size: NSSize(width: 270, height: 270)))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
            
            HStack {
                Text("Download as image")
                Spacer()
                Button {
                    saveImage()
                } label: {
                    Text("Download")
                }
                .buttonStyle(.borderedProminent)
            }
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
            for: qrText
            //            backgroundColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0),
            //            foregroundColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1)
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
