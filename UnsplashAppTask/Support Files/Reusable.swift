//
//  Reusable.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        String(describing: self)
    }
}
