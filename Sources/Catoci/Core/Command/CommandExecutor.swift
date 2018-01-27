//
//  CommandExecutor.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation

class CommandExecutor {
    
    var executingConversaition: Bool {
        return currentConversationCommand != nil
    }
    
    private var currentConversationCommand: Command?
    
    func execute(_ commands: [ExecutableCommand], replyingTo originalSender: MessageSender) {
        for executable in commands {
            
            let command = executable.command
            

            
//            if commands.count > 1 {
//                sender = PrefixedMessageSender(prefix: "[\(executable.command.name)]", sender: originalSender)
//            }
            
            if executable.parameters.first == .some("usage") {
                originalSender.send(executable.command.usage ?? "Wrong command")
            } else if executable.parameters.first == .some("description") {
                originalSender.send(executable.command.description ?? "Wrong command")
            } else {
                do {
                    try executable.command.execute(with: executable.parameters, replyingTo: originalSender)
                    if command.isConversation && !command.conversationEnded {
                        "saving command coz it is conversation".log()
                        currentConversationCommand = command
                    }
                    if let nextQuestion = command.unansweredQuestion {
                        originalSender.send(nextQuestion.question)
                    }
                } catch {
                    originalSender.send(error.userFriendlyMessage)
                    break
                }
            }
        }
    }
    
    func executeConversation(from message: String, replyingTo originalSender: MessageSender) {
        guard let command = currentConversationCommand else {
            return
        }
        
        var conversation = command.unansweredQuestion
        conversation?.answer = message
        
        if let nextQuestion = command.unansweredQuestion {
            originalSender.send(nextQuestion.question)
        } else {
            var message = ""
            command.conversation.forEach { conversation in
                message.append("I asked *\(conversation.question)*\nYou answered *\(conversation.answer!)*\n")
            }
            originalSender.send(message)
            command.restartConversation()
            currentConversationCommand = nil
        }
    }
}
