//
//  ColorPickerView.swift
//  QR Generator
//
//  Created by Rishi Singh on 18/09/23.
//

import SwiftUI

struct ColorPickerView: View {
    let title: String
    @Binding var colorHue: Double
    @Binding var colorBrightness: Double
    @Binding var colorOpacity: Double
    @Binding var isWhite: Bool
    
    let onColorChange: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Toggle("White", isOn: $isWhite)
                    .onChange(of: isWhite) { _ in
                        onColorChange()
                    }
            }
            Text("Color")
            HStack {
                Slider(value: $colorHue)
                    .onChange(of: colorHue) { _ in
                        onColorChange()
                    }
                    .disabled(isWhite)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hue: colorHue, saturation: 1, brightness: 1))
                    .frame(width: 30, height: 20)
            }
            Text("Brightness")
            HStack {
                Slider(value: $colorBrightness)
                    .onChange(of: colorBrightness) { _ in
                        onColorChange()
                    }
                    .disabled(isWhite)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hue: colorHue, saturation: 1, brightness: colorBrightness))
                    .frame(width: 30, height: 20)
            }
            Text("Opacity")
            HStack {
                Slider(value: $colorOpacity)
                    .onChange(of: colorOpacity) { _ in
                        onColorChange()
                    }
                    .disabled(isWhite)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hue: colorHue, saturation: colorOpacity, brightness: colorBrightness))
                    .frame(width: 30, height: 20)
            }
        }
        .padding(.horizontal)
        .padding(.horizontal, 3)
    }
}

//struct SliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorPickerView()
//    }
//}
