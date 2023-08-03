//
//  CoreDataLocalPokemonListStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/3/23.
//

import CoreData

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        return container
    }
}

public final class CoreDataLocalPokemonListStore: LocalPokemonListStore {
    private static let modelName = "PokemonListStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataLocalPokemonListStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeUrl: URL) {
        container = try! NSPersistentContainer.load(
            name: Self.modelName,
            model: Self.model!,
            url: storeUrl
        )
        context = container.newBackgroundContext()
    }
    
    public func retrieve() throws -> CachedPokemonList? {
        try performSync { context in
            Result {
                try ManagedPokemonListCache.find(in: context).map {
                    .init(local: $0.local, timestamp: $0.timestamp)
                }
            }
        }
    }
    
    public func delete() throws {
        
    }
    
    public func insert(local: LocalPokemonList, timestamp: Date) throws {
        try performSync { context in
            Result {
                let cache = ManagedPokemonListCache(context: context)
                let list = ManagedPokemonListItem.listItems(from: local, in: context)
                cache.timestamp = timestamp
                cache.pokemonList = list
                try context.save()
            }
        }
    }
    
    private func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
}

extension ManagedPokemonListCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedPokemonListCache? {
        let request = NSFetchRequest<ManagedPokemonListCache>(entityName: entity().name!)
        return try context.fetch(request).first
    }
    
    var local: LocalPokemonList {
        return pokemonList.compactMap { ($0 as? ManagedPokemonListItem)?.local }
    }
}

extension ManagedPokemonListItem {
    var local: LocalPokemonListItem {
        let specialType: LocalPokemonListItemType?
        if let specialColor, let specialName {
            specialType = .init(color: specialColor, name: specialName)
        } else {
            specialType = nil
        }
        return .init(id: id, name: name, imageUrl: imageUrl, physicalType: .init(color: physicalColor, name: physicalName), specialType: specialType)
    }
    
    static func listItems(from localList: LocalPokemonList, in context: NSManagedObjectContext) -> NSOrderedSet {
        let items = NSOrderedSet(array: localList.map { local in
            let managed = ManagedPokemonListItem(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.physicalColor = local.physicalType.color
            managed.physicalName = local.physicalType.name
            managed.specialColor = local.specialType?.color
            managed.specialName = local.specialType?.name
            managed.imageUrl = local.imageUrl
            return managed
        })
        return items
    }
}
