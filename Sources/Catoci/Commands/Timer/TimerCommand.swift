//
//  TimerCommand.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/27/18.
//
//

import Foundation

class TimerCommand: Command {
    var timer: Timer? {
        didSet {
            
        }
    }
    
    var name: String? {
        return "cat"
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
//        if #available(OSX 10.12, *) {
//            timer = Timer.init(timeInterval: 10, repeats: true) { timer in
//                sender.send("😽 http://thecatapi.com/?id=3ki http://25.media.tumblr.com/tumblr_lyxm5waoQQ1r4c11po1_500.jpg")
//            }
//            timer?.fire()
//        } else {
//            // Fallback on earlier versions
//        }
        
        if #available(OSX 10.12, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { timer in
                sender.send("😽 http://25.media.tumblr.com/tumblr_lyxm5waoQQ1r4c11po1_500.jpg")
            })
            timer?.fire()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func restartConversation() {}
    
    
    @objc func loop() {
        let liveInfoUrl = URL(string: "http://192.168.1.66/api/cloud/app/liveInfo/7777")
        let task = URLSession.shared.dataTask(with: liveInfoUrl! as URL) {data, response, error in
            guard let data = data, error == nil else { return }
            print(String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? "Not available")
        }
        task.resume()
    }
}
