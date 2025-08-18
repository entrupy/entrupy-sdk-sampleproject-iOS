//
//  Alert.swift
//  Sneaker Authentication Demo
//
//  Created by Felipe Garcia on 26/07/2022.
//

import SwiftUI

struct AlertData {
  let title: Text
  let message: Text?
  let dismissButton: Alert.Button?

  static let empty = AlertData(title: Text(""),
                               message: nil,
                               dismissButton: nil)
}

public extension Notification.Name {
  static let showAlert = Notification.Name("showAlert")
}
