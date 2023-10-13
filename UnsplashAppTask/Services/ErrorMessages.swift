//
//  ErrorMessages.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

enum ErrorMessages: String, Error {
    case invalidRequest     = "This request created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    
    case badRequest = "Unfortunately your request didn't find any results!"
    case accessDenied = "Your access is denied!"
    case notFound = "Unfortunately your request didn't find any images!"
    case successfull
    case invalidHTTPRequest = "Something went wrong..."
    case invalidJSONDecoder = "Something went wrond, we are fixing it right now..."
}
