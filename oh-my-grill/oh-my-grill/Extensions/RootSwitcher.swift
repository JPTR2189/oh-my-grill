//
//  RootSwitcher.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 09/12/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    func switchToHome<Content: View>(view: Content) {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        window.rootViewController = UIHostingController(rootView: view)
        window.makeKeyAndVisible()
    }
}
