//
//  CoreDataStack.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-12-14.
//  Copyright © 2021 Pawel Wiszenko, mrfour, Taylor Young. All rights reserved.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private let storageType: StorageType

    init(_ storageType: StorageType = .persistent) {
        self.storageType = storageType

        if case .inmemory(let sampleData) = storageType {
            self.initializeWithSampleData(with: sampleData)
        }
    }

    lazy var persistentContainer: NSPersistentContainer = {
        if case .inmemory(_) = storageType {
            let container = NSPersistentContainer(name: "Stockpile")
            let description = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/dev/null"))
            container.persistentStoreDescriptions = [description]

            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }

            return container
        } else {
            // Modified from https://stackoverflow.com/a/57020353
            let container = NSPersistentContainer(name: "Stockpile")
            let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.io.github.taylor-young0.Stockpile")!.appendingPathComponent("Stockpile.sqlite")

            var defaultURL: URL?
            if let storeDescription = container.persistentStoreDescriptions.first, let url = storeDescription.url {
                defaultURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
            }

            if defaultURL == nil {
                container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
            }
            container.loadPersistentStores(completionHandler: { [unowned container] (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }

                if let url = defaultURL, url.absoluteString != storeURL.absoluteString {
                    let coordinator = container.persistentStoreCoordinator
                    if let oldStore = coordinator.persistentStore(for: url) {
                        do {
                            try coordinator.migratePersistentStore(oldStore, to: storeURL, options: nil, withType: NSSQLiteStoreType)
                        } catch {
                            print(error.localizedDescription)
                        }

                        // delete old store
                        let fileCoordinator = NSFileCoordinator(filePresenter: nil)
                        fileCoordinator.coordinate(writingItemAt: url, options: .forDeleting, error: nil, byAccessor: { url in
                            do {
                                try FileManager.default.removeItem(at: url)
                            } catch {
                                print(error.localizedDescription)
                            }
                        })
                    }
                }
            })
            return container
        }
    }()
}

// MARK: - Main context

extension CoreDataStack {
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        managedObjectContext.performAndWait {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Working context

extension CoreDataStack {
    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }

    func saveWorkingContext(context: NSManagedObjectContext) {
        do {
            try context.save()
            saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}

/// Taken from: https://stackoverflow.com/a/60266079/8697793
extension NSManagedObjectContext {
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    public func executeAndMergeChanges(_ batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}

extension FileManager {
    static let appGroupContainerURL = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.io.github.taylor-young0.Stockpile")!
}
