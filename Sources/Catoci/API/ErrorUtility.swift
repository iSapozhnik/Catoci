//
//  ErrorUtility.swift
//  Catoci
//
//  Created by Ivan Sapozhnik on 1/26/18.
//
//

import Foundation

extension Error {
    
    var userFriendlyMessage: String {
        if let string = self as? String {
            return string
        } else {
            return self.localizedDescription
        }
    }
    
}

extension String: Error {}
