//
//  SlackMessageSender.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation
import Vapor

fileprivate struct SlackMessage {
    
    static var messageCounter: Int = 0
    static var lastTimestamp: UInt64 = 0
    
    let id: UInt64
    let channel: String
    let text: String
    
    init(to channel: String, text: String) {
        
        let timestamp = UInt64(floor(Date().timeIntervalSince1970))
        if timestamp != SlackMessage.lastTimestamp {
            SlackMessage.lastTimestamp = timestamp
            SlackMessage.messageCounter = 0
        }
        
        self.id = timestamp * 1000 + UInt64(SlackMessage.messageCounter)
        SlackMessage.messageCounter += 1
        self.channel = channel
        self.text = text
    }
}

extension SlackMessage: NodeRepresentable {
    
    func makeNode(in context: Context?) throws -> Node {
        return try Node(node: ["id": id, "channel": channel,
                               "type": "message",
                               "text": text])
    }
}

extension WebSocket {
    func send(_ node: NodeRepresentable) throws {
        let json = try node.converted(to: JSON.self, in: nil)
        let message = try json.makeBytes()
        try send(message.makeString())
    }
}


class SlackMessageSender: MessageSender {
    
    private let socket: WebSocket
    private let channel: String
    init(socket: WebSocket, channel: String) {
        self.socket = socket
        self.channel = channel
    }
    
    func send(_ message: String) {
        let slackMessage = SlackMessage(to: self.channel, text: message)
        try! self.socket.send(slackMessage)
    }
}
