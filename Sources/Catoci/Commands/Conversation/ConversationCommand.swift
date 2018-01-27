//
//  ConversationCommand.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/27/18.
//
//

import Foundation

class NameQuestion: Conversation {
    var question: String {
        return "What is your name?"
    }
    var answer: String?
}

class AgeQuestion: Conversation {
    var question: String {
        return "How old are you?"
    }
    var answer: String?
}

class ConversationCommand: Command {
    
    private var questions: [Conversation] = [NameQuestion(), AgeQuestion()]
    
    var name: String? {
        return "hi"
    }
    
    var description: String? {
        return ""
    }
    
    var usage: String? {
        return "Just type `hi` and I will reply"
    }
    
    var conversation: [Conversation] {
        return questions
    }
    
    func execute(with parameters: [String], replyingTo sender: MessageSender) throws {
        sender.send("😽 Hi there...")
    }
    
    func restartConversation() {
        questions = [NameQuestion(), AgeQuestion()]
    }
}
