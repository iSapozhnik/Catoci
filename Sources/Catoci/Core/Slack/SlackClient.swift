//
//  SlackClient.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation
import Vapor
import HTTP
import TLS
import Transport

extension ClientFactoryProtocol {
    func loadRealtimeApi(token: String, simpleLatest: Bool = true, noUnreads: Bool = true) throws -> HTTP.Response {
        let headers: [HeaderKey: String] = ["Accept": "application/json; charset=utf-8"]
        let query: [String: NodeRepresentable] = [
            "token": token,
            "simple_latest": simpleLatest ? 1 : 0,
            "no_unreads": noUnreads ? 1 : 0
        ]
        return try self.get(
            "https://slack.com/api/rtm.start",
            query: query,
            headers)
    }
}

class SlackClient {
    
    private let token: String
    private let droplet: Droplet
    init(token: String, droplet: Droplet) {
        self.token = token
        self.droplet = droplet
    }
    
    func connect(onMessage: @escaping (_ message: String, _ sender: MessageSender) -> Void) throws {
        
        let rtmResponse = try self.droplet.client.loadRealtimeApi(token: self.token)
        guard let webSocketURL = rtmResponse.json?["url"]?.string else {
            throw "Unable to retrieve `url` from slack. Reason \(rtmResponse.status.reasonPhrase). Raw response \(rtmResponse.data)"
        }
        
        try WebSocketFactory.shared.connect(to: webSocketURL) { (socket) in
            print("Connected to \(webSocketURL)")
            
            socket.onText = { ws, text in
                print("[event] - \(text)")
                
                let event = try JSON(bytes: text.utf8.array)
                
                guard
                    let channel = event["channel"]?.string,
                    let text = event["text"]?.string
                    else { return }
                
                let sender = SlackMessageSender(socket: socket, channel: channel)
                
                onMessage(text, sender)
            }
            
            socket.onClose = { _ in
                print("\n[CLOSED]\n")
            }
        }
    }
}
