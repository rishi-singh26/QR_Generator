//
//  HexColorInputView.swift
//  QR Generator
//
//  Created by Rishi Singh on 19/09/23.
//

import SwiftUI

struct HexColorInputView: View {
    @Binding var isHintShowing: Bool
    @Binding var textBoxValue: String
    let title: String
    var body: some View {
        HStack {
            HStack(spacing: 3) {
                Text(title)
                Button {
                    isHintShowing = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(isHintShowing ? Color.accentColor : Color.primary)
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $isHintShowing) {
                    Text("Enter color hex code, "
                         + "Hex code for white is #FFFFFF and for black it is #000000. "
                         + "Search web for \"color picker\" to find hex code for your color."
                    )
                    .frame(width: 400)
                    .padding()
                }
            }
            Spacer()
            TextField("FFFFFF", text: $textBoxValue)
                .textFieldStyle(.roundedBorder)
                .textCase(.uppercase)
                .frame(width: 100)
        }
    }
}

struct HexColorInputView_Previews: PreviewProvider {
    static var previews: some View {
        HexColorInputView(isHintShowing: .constant(false), textBoxValue: .constant("FFFFFF"), title: "Color")
    }
}
