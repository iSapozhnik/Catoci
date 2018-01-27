//
//  CircleCI.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/27/18.
//
//

import Foundation

class CircleCiCommand: Command {
    
    private let circleCIClient = CircleCIClient()
    
    var name: String? {
        return "ci"
    }
    
    var description: String? {
        return ""
    }
    
    var usage: String? {
        return ""
    }
    
    var conversation: [Conversation] {
        return []
    }
    
    func execute(with parameters: [String], replyingTo sender: MessageSender) throws {
        sender.send("😼 Executing `\(name ?? "ci")` command...")
        
        circleCIClient.start { response in
            sender.send("😺 found: \(response)")
        }
    }
    
    func restartConversation() {}
}
