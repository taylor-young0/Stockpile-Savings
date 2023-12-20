//
//  ManagedObjectContextProtocol.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-12-20.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import CoreData

protocol ManagedObjectContextProtocol {
    func save() throws
}

extension NSManagedObjectContext: ManagedObjectContextProtocol {

}

class MockManagedObjectContext: ManagedObjectContextProtocol {
    var hasSaved = false
    var throwError: Bool = false

    func save() throws {
        if throwError {
            throw NSError()
        }
        hasSaved = true
    }
}
