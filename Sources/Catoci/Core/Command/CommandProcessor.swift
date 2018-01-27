//
//  CommandProcessor.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation

class CommandProcessor {
    
    struct ProcessingError: Error {
        let commandName: String
    }
    
    private let factory: CommandFactory
    init(factory: CommandFactory) {
        self.factory = factory
    }

    func executableCommands(from message: String) throws -> [ExecutableCommand] {
        
        var commands: [ExecutableCommand] = []
        let commandLines = message.components(separatedBy: "|").map({ $0.trimmingCharacters(in: .whitespaces) })
        "executor -> commandLines: \(commandLines)".log()
        
        for commandLine in commandLines {
            var parameters = commandLine.components(separatedBy: " ")
            guard parameters.count > 0 else { continue }
            let commandName = parameters[0]
            parameters.remove(at: 0) // Remove the first 'commandName' element
            
            let command = self.factory.command(withName: commandName)
            
            if let command = command {
                commands.append(ExecutableCommand(command: command, parameters: parameters))
            } else {
                "executor -> throwing error for command name: \(commandName)".log()
                throw ProcessingError(commandName: commandName)
            }
        }
        
        "executor -> commands: \(commands)".log()
        return commands
    }
    
}
