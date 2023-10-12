//
//  Collection+Extension.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
