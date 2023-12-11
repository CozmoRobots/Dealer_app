//
//  Connection.swift
//  BlackJack_swiftUI
//
//  Created by Haruko Okada on 10/29/23.
//

import Foundation
import Network

class Network: ObservableObject {
    
    var hostP: String
    var portP: UInt16
    
    var connection: NWConnection
    init() {
        self.hostP = "10.0.1.10"
        self.portP = 5000
        let host = NWEndpoint.Host(self.hostP)
        let port = NWEndpoint.Port(integerLiteral: self.portP)
        self.connection = NWConnection(host: host, port: port, using: .tcp)
    }
    
    func open(ip: String, port: UInt16) -> String{
        self.hostP = ip
        self.portP = port
        let host = NWEndpoint.Host(ip)
        let port = NWEndpoint.Port(integerLiteral: port)
        var netState: String?
        
        self.connection = NWConnection(host: host, port: port, using: .tcp)
        self.connection.stateUpdateHandler = { (newState) in
            switch(newState) {
            case .ready:
                netState = "Ready"
            case .waiting(let error):
                netState = "Waiting - \(error)"
            case .failed(let error):
                netState = "Failed - \(error)"
            case .setup:
                netState = "Setup"
            case .cancelled:
                netState = "Cancelled"
            case .preparing:
                netState = "Preparing"
            default:
                netState = "Default"
            }
        }
        let netQueue = DispatchQueue(label: "NetworkClient")
        self.connection.start(queue: netQueue)
        
        for _: Int32 in 0..<100000 {
            if let netState = netState {
                if netState == "Ready" {
                    return(netState)
                }
            }
        }
        return "Time Out Error"
    }
    
    func send(sText: String) -> (sentS: String, statS: String) {
        var netState: String?
        let sendData = "\(sText)".data(using: .utf8)!
        
        self.connection.send(content: sendData, completion: .contentProcessed { (error) in
            if let error = error {
                netState = "\(#function), \(error)"
            } else {
                netState = "success"
            }
        })
                        
        for _: Int32 in 0..<100000 {
            if let netState = netState {
                if netState == "success" {
                    return (sText, netState)
                }
            }
        }
                    
        return (sText, "Time Out Error")
    }
    
    func close() -> String {
           let netState: String = "Close"
           connection.cancel()
           return netState
    }

}

