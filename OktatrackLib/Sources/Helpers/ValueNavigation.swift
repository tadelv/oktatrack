//
//  ValueNavigation.swift
//  
//
//  Created by Vid Tadel on 2/3/23.
//

import SwiftUI

extension View {
  public func navigateIfValue<Value: Equatable, Destination: View>(
    _ value: Binding<Value?>,
    destination: @escaping (Value) -> Destination
  ) -> some View {
    self
      .modifier(ValueNavigationDestination(value: value, destination: destination))
  }
}

struct ValueNavigationDestination<Value: Equatable, Destination: View>: ViewModifier {
  @Binding var value: Value?
  @ViewBuilder var destination: (Value) -> Destination
  @State var shows: Bool = false

  init(value: Binding<Value?>, destination: @escaping (Value) -> Destination) {
    self._value = value
    self.destination = destination
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: shows, perform: { newValue in
        if !newValue {
          value = nil
        }
      })
      .onChange(of: value, perform: { newValue in
        shows = newValue != nil
      })
      .navigationDestination(isPresented: $shows) {
        if let value {
          destination(value)
        }
      }
  }
}
