//
//  Catoci.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation
import Vapor

class Catoci {
    static let version = "0.99 😺"
    
    struct Configuration {
        let slackToken: String
        
        init(slackToken: String) {
            self.slackToken = slackToken
        }
    }
    
    private let slackClient: SlackClient
    private let commandFacoty: CommandFactory
    private let commandProcessor: CommandProcessor
    private let commandExecutor: CommandExecutor
    
    public init(config: Configuration, droplet: Droplet) {
        self.slackClient = SlackClient(token: config.slackToken, droplet: droplet)
        
        print("Catoci v:\(Catoci.version) has been initialized...")
        
        self.commandFacoty = CommandFactory(commands: [
            HelloCommand(),
            CircleCiCommand()
        ])
        
        self.commandProcessor = CommandProcessor(factory: self.commandFacoty)
        self.commandExecutor = CommandExecutor()
    }
    
    public func start() throws {
        try self.slackClient.connect { (message, sender) in
            
            do {
                let commands = try self.commandProcessor.executableCommands(from: message)
                "commands: \(commands)".log()
                if commands.count > 0 {
                    self.commandExecutor.execute(commands, replyingTo: sender)
                } else {
                    let didntGet = ExecutableCommand(command: DidntGetCommand(), parameters: [])
                    self.commandExecutor.execute([didntGet], replyingTo: sender)
                }
            } catch {
                "catching exception".log()
                if let processingError = error as? CommandProcessor.ProcessingError {
                    let errorMessage = "😿 Could not find command with name `\(processingError.commandName)`.\n"
                        + self.commandFacoty.availableCommands
                        + "\nIf you want to know more about a command, you can do:\n`{command} usage`"
                    sender.send(errorMessage)
                } else {
                    sender.send(error.userFriendlyMessage)
                }
            }
        }
    }
}

extension String {
    func log() {
        print("😺 " + self)
    }
}

protocol MessageSender {
    func send(_ message: String)
}
