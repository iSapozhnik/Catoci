//
//  HelloCommand.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation

class HelloCommand: Command {
    var name: String? {
        return "hello"
    }
    
    var description: String? {
        return "Command which doing nothing but just replying on your `hello` command"
    }
    
    var usage: String? {
        return "Just type `hello` and I will reply"
    }
    
    func execute(with parameters: [String], replyingTo sender: MessageSender) throws {
        sender.send("😽 Hi there...")
    }
}
