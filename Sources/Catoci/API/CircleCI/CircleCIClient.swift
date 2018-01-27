//
//  CircleCIClient.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/27/18.
//
//

import Foundation
import Vapor

class CircleCIClient {
    struct Config {
        static let baseURLString = "https://circleci.com/api/v1.1/"
        
        // All projects
        // https://circleci.com/api/v1.1/projects?circle-token=:token
        
        //https://circleci.com/api/v1.1/project/:vcs-type/:username/:project?circle-token=:token&limit=20&offset=5&filter=completed
    }
    
    enum Endpoint {
        case allProjects(String)
        case me(String)
        
        var stringRepresentation: String {
            switch self {
            case .allProjects(let token):
                return Config.baseURLString+"projects?"+"circle-token="+token
            case .me(let token):
                return Config.baseURLString+"me?"+"circle-token="+token
            }
        }
    }
    
    func start(_ completion: @escaping (String) -> Void) {
        let token = Configuration.token
        do {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let url = URL(string: Endpoint.allProjects(token).stringRepresentation)!
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print(data) // JSON Serialization
                    guard let data = data else {
                        print("Data is empty")
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        "CircleCIClient -> body: \(json)".log()
                        
                        var projectNames = ""
                        if let array = json as? [Any] {
                            
                            for project in array {
                                // access all objects in array
                                let proj = project as! Dictionary<String, Any>
                                projectNames += "\n\(proj["reponame"]!)"
                            }
                        }

                        completion(projectNames)
                    }
                    catch let error {
                        "CircleCIClient -> error: \(error)".log()
                    }

                }
            }
            task.resume()

        }
        catch let error {
            "CircleCIClient -> error: \(error)".log()
        }
    }
}
