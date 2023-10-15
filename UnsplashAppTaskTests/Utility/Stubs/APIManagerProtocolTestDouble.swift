//
//  APIManagerProtocolTestDouble.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import Foundation

final class APIManagerProtocolTestDouble: APIManagerProtocol {
    var getImagesByRequestForSearchRequestPageCompletedCallsCount: Int = .zero
    var getImagesByRequestForSearchRequestPageCompletedIsCalled: Bool {
        getImagesByRequestForSearchRequestPageCompletedCallsCount > .zero
    }
    var getImagesByRequestForSearchRequestPageSearchRequest: String?
    var getImagesByRequestForSearchRequestPagePage: Int?
    var getImagesByRequestForSearchRequestPageReturnValue: Result<APIResponse, ErrorMessages>?

    func getImagesByRequest(for searchRequest: String, page: Int, completed: @escaping (Result<APIResponse, ErrorMessages>) -> Void) {
        getImagesByRequestForSearchRequestPageCompletedCallsCount += 1
        getImagesByRequestForSearchRequestPageSearchRequest = searchRequest
        getImagesByRequestForSearchRequestPagePage = page
        if let getImagesByRequestForSearchRequestPageReturnValue {
            completed(getImagesByRequestForSearchRequestPageReturnValue)
        }
    }

    var getRandomImagesPageCompletedCallsCount: Int = .zero
    var getRandomImagesPageCompletedIsCalled: Bool {
        getRandomImagesPageCompletedCallsCount > .zero
    }
    var getRandomImagesPageCompletedPageValue: Int?
    var getRandomImagesPageCompletedReturnValue: Result<[RandomImagesResult], ErrorMessages>?

    func getRandomImages(page: Int, completed: @escaping (Result<[RandomImagesResult], ErrorMessages>) -> Void) {
        getRandomImagesPageCompletedCallsCount += 1
        getRandomImagesPageCompletedPageValue = page
        if let getRandomImagesPageCompletedReturnValue {
            completed(getRandomImagesPageCompletedReturnValue)
        }
    }

    var getImagesByIDForIDCompletedCallsCount: Int = .zero
    var getImagesByIDForIDCompletedIsCalled: Bool {
        getImagesByIDForIDCompletedCallsCount > .zero
    }
    var getImagesByIDForIDCompletedIDValue: String?
    var getImagesByIDForIDCompletedReturnValue: Result<ImageResult, ErrorMessages>?

    func getImagesByID(for id: String, completed: @escaping (Result<ImageResult, ErrorMessages>) -> Void) {
        getImagesByIDForIDCompletedCallsCount += 1
        getImagesByIDForIDCompletedIDValue = id
        if let getImagesByIDForIDCompletedReturnValue {
            completed(getImagesByIDForIDCompletedReturnValue)
        }
    }
}
