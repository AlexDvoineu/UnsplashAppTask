//
//  ConnectivityService.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 16.10.23.
//

import CoreTelephony
import SwiftMessages
import Network
import NetworkExtension

import UIKit

enum ConnectionState {
    case unknown, satisfied, restrictedCellular, noConnection
    
    var errorMessage: String? {
        switch self {
        case .unknown, .satisfied:
            return nil
        case .restrictedCellular:
            return R.string.localizable.enableCellularDataForUsage()
        case .noConnection:
            return R.string.localizable.noInternetConnection()
        }
    }
    
    var color: UIColor {
        if self == .noConnection {
            return .orange
        }
        return .red
    }
}

final class ConnectivityService {
    
    let noInternetMessageView = MessageView.viewFromNib(layout: .statusLine)
    
    private var connectionState: ConnectionState = .unknown {
        didSet { showConnectionErrorIfNeeded() }
    }
    
    private var cellularDataRestrictedState = CTCellularDataRestrictedState.restrictedStateUnknown {
        didSet { showConnectionErrorIfNeeded() }
    }
    
    private var isCellularDataRestricted: Bool { cellularDataRestrictedState == .restricted }
    
    init(connectionState: ConnectionState = .unknown) {
        self.connectionState = connectionState
    }
    
    func startObservingConnectivity() {
        startMonitoringCellularRestriction()
        startMonitoringConnection()
    }
    
    func showConnectionErrorIfNeeded() {
        guard ![.disconnecting, .connecting].contains(NEVPNManager.shared().connection.status) else { return }
        
        DispatchQueue.main.async {
            if let errorMessage = self.connectionState.errorMessage {
                self.showBanner(text: errorMessage, color: self.connectionState.color)
            } else {
                SwiftMessages.hideAll()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func startMonitoringCellularRestriction() {
        let cellularState = CTCellularData.init()
        cellularState.cellularDataRestrictionDidUpdateNotifier = { (dataRestrictedState) in
            self.cellularDataRestrictedState = dataRestrictedState
        }
    }
    
    private func startMonitoringConnection() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connectionState = .satisfied
            } else if path.usesInterfaceType(.cellular), self.isCellularDataRestricted {
                self.connectionState = .restrictedCellular
            } else {
                self.connectionState = .noConnection
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    private func showBanner(text: String, color: UIColor) {
        noInternetMessageView.backgroundView.backgroundColor = color
        noInternetMessageView.bodyLabel?.textColor = .white
        noInternetMessageView.configureContent(body: text)
        
        var noInternetMessageViewConfig = SwiftMessages.defaultConfig
        noInternetMessageViewConfig.presentationContext = .window(windowLevel: .init(rawValue: 0))
        noInternetMessageViewConfig.preferredStatusBarStyle = .lightContent
        noInternetMessageViewConfig.duration = .forever
        SwiftMessages.show(config: noInternetMessageViewConfig, view: noInternetMessageView)
    }
}
