//
//  View+Ext.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

extension View {
    func dw(_ value: Double) -> Double {
        uiWidth * value
    }
    
    func dh(_ value: Double) -> Double {
        uiHeight * value
    }
}

extension View {
    func rotate(_ degrees: Double) -> some View {
        return self.rotationEffect(Angle(degrees: degrees))
    }
}
