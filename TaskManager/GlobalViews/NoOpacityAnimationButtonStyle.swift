//
//  NoOpacityAnimationButtonStyle.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 20.11.2023.
//

import SwiftUI

struct NoOpacityAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
