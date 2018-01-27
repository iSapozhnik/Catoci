//
//  CommandExecutor.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation

class CommandExecutor {
    
    func execute(_ commands: [ExecutableCommand], replyingTo originalSender: MessageSender) {
        for executable in commands {
            
            var sender = originalSender
//            if commands.count > 1 {
//                sender = PrefixedMessageSender(prefix: "[\(executable.command.name)]", sender: originalSender)
//            }
            
            if executable.parameters.first == .some("usage") {
                sender.send(executable.command.usage ?? "Wrong command")
            } else if executable.parameters.first == .some("description") {
                sender.send(executable.command.description ?? "Wrong command")
            } else {
                do {
                    try executable.command.execute(with: executable.parameters, replyingTo: sender)
                } catch {
                    sender.send(error.userFriendlyMessage)
                    break
                }
            }
        }
    }
    
}
