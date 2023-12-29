//
//  ManagedObjectContextType.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-12-20.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import CoreData

protocol ManagedObjectContextType {
    func save() throws
    func delete(_ object: NSManagedObject)
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult
}

extension NSManagedObjectContext: ManagedObjectContextType {

}

class MockManagedObjectContext: ManagedObjectContextType {
    var throwError: Bool

    init(throwError: Bool = true) {
        self.throwError = throwError
    }

    func save() throws {
        if throwError {
            throw NSError()
        }
    }

    func delete(_ object: NSManagedObject) {

    }

    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        if throwError {
            throw NSError()
        }

        return []
    }
}
