//
//  ValueNavigation.swift
//  
//
//  Created by Vid Tadel on 2/3/23.
//

import SwiftUI

extension View {
  public func navigateIfValue<Value, Destination: View>(
    _ value: Binding<Value?>,
    destination: @escaping (Value) -> Destination
  ) -> some View {
    self
      .modifier(NonEquatableDestination(value: value, destination: destination))
  }
}

struct NonEquatableDestination<Value, Destination: View>: ViewModifier {
  @Binding var value: Value?
  @ViewBuilder var destination: (Value) -> Destination

  func body(content: Content) -> some View {
    content
      .navigationDestination(isPresented: .init(get: {
        value != nil
      }, set: { showing, transaction in
        if !showing {
          $value.transaction(transaction).wrappedValue = nil
        }
      })) {
        if let value {
          destination(value)
        }
      }
  }
}
