//
//  Date+Ext.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import Foundation

extension Date {
    func toStringDate(_ format: String = "dd.MM.yyyy HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
