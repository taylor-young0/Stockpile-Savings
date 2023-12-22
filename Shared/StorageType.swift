//
//  StorageType.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-12-22.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

enum SampleDataAmount {
    case none, one, few, many, manyWithDuplicates
}

enum StorageType {
    case persistent, inmemory(SampleDataAmount)

    var managedObjectContext: ManagedObjectContextType {
        if case .persistent = self {
            return CoreDataStack.shared.managedObjectContext
        }

        return CoreDataStack(self).managedObjectContext
    }
}
