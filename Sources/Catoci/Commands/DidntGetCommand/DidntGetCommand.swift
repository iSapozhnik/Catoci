//
//  DidntGetCommand.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation

class DidntGetCommand: Command {
    var name: String? { return nil }
    var description: String? { return nil }
    var usage: String? { return nil }
    var conversation: [Conversation] {
        return []
    }
    
    func execute(with parameters: [String], replyingTo sender: MessageSender) throws {
        sender.send("😿 I didn't get...")
    }
    
    func restartConversation() {}
}
