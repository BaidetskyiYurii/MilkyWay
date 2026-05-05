//
//  InputTextFieldView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 16.04.2026.
//

import SwiftUI

enum InputTextFieldType {
    case routeName
    case pinName

    var placeholder: String {
        switch self {
        case .routeName:
            "Set your route name"
        case .pinName:
            "Set a pin name"
        }
    }
    
//    var image: String {
//        switch self {
//        case .routeName:
//            "pencil"
//        }
//    }
}

struct InputTextFieldView: View {
    private let type: InputTextFieldType
    
    @Binding private var text: String
    private var isFocused: FocusState<Bool>.Binding
    
    private var isActive: Bool {
        isFocused.wrappedValue || !text.isEmpty
    }
    
    init(
        type: InputTextFieldType,
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding
    ) {
        self.type = type
        self._text = text
        self.isFocused = isFocused
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 10) {
                // TODO: Add image if needed
                
                textField
                
                if !text.isEmpty && isFocused.wrappedValue {
                    clearButton
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 16)
            .frame(height: 50)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.mwBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(isFocused.wrappedValue ? Color.mwLavender : .mwBorder, lineWidth: 1)
        }
        .overlay(alignment: .topLeading) {
            overlayText
        }
    }
}

// MARK: Views
private extension InputTextFieldView {
    var overlayText: some View {
        Text(type.placeholder)
            .foregroundColor(isActive ? .mwLavender : .mwPlaceholderText)
            .font(
                isActive
                ? Fonts.Poppins.regular.swiftUIFont(size: 12)
                : Fonts.Poppins.regular.swiftUIFont(size: 14)
            )
            .padding(.horizontal, 6)
            .background(Color.mwBackground)
            .offset(x: 18, y: isActive ? -9 : 15)
            .scaleEffect(isActive ? 1 : 1, anchor: .leading)
            .animation(.easeInOut(duration: 0.2), value: isActive)
            .allowsHitTesting(false)
    }
    
    var clearButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                text = ""
                isFocused.wrappedValue = false
            }
        } label: {
            Image(systemName: "xmark.circle")
                .foregroundStyle(.mwLavender)
        }
    }
    
    var textField: some View {
        TextField("", text: $text)
            .foregroundColor(.mwText)
            .font(Fonts.Poppins.regular.swiftUIFont(size: 16))
            .tint(.mwLavender)
            .focused(isFocused)
    }
}

fileprivate struct InputTextFieldViewPreviewWrapper: View {
    @State private var text = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            InputTextFieldView(
                type: .pinName,
                text: $text,
                isFocused: $isFocused
            )
            .padding()
            
            Spacer()
        }
        .background(Color.mwBackground)
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    InputTextFieldViewPreviewWrapper()
}
