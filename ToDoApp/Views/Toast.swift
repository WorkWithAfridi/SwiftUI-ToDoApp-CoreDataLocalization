//
//  Toast.swift
//  ToDoApp
//
//  Created by Khondakar Afridi on 11/27/23.
//

import Foundation
import SwiftUI

struct ToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    var message: String

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                content
                if isPresented {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(message)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                                .padding()
                                .frame(width: geometry.size.width * 0.8)
                            Spacer()
                        }
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20) // Adjust bottom padding
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.5))
                    .onTapGesture {
                        isPresented = false
                    }
                }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastViewModifier(isPresented: isPresented, message: message))
    }
}
