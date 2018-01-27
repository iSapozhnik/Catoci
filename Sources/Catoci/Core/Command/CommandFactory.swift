//
//  CommandFactory.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation

protocol Command {
    var name: String? { get }
    var description: String? { get }
    var usage: String? { get }
    func execute(with parameters: [String], replyingTo sender: MessageSender) throws
}

struct ExecutableCommand {
    
    let command: Command
    let parameters: [String]
    
}

class CommandFactory {
    
    private(set) var commands: [Command] = []
    
    var availableCommands: String {
        var string = "Available commands:"
        self.commands.forEach({ string += "\n• " + $0.name!})
        return string
    }
    
    init(commands: [Command]) {
        self.commands = commands
    }
    
    func command(withName name: String) -> Command? {
        let lowercasedName = name.lowercased()
        return self.commands.first(where: { $0.name?.lowercased() == lowercasedName })
    }
}
