//
//  CommandFactory.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation

protocol Conversation {
    var question: String { get }
    var answer: String? { get set }
//    mutating func  updateAnswer(_ answer: String)
}

protocol Command {
    var name: String? { get }
    var description: String? { get }
    var usage: String? { get }
    var conversation: [Conversation] { get }
    func execute(with parameters: [String], replyingTo sender: MessageSender) throws
    func restartConversation()
}

extension Command {
    var isConversation: Bool {
        return conversation.count > 0
    }
    
    var conversationEnded: Bool {
        return conversation.count == 0 || conversation.filter { $0.answer == nil }.count == 0
    }
    
    var unansweredQuestion: Conversation? {
        return conversation.filter { $0.answer == nil }.first
    }
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
