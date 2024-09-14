import Foundation
import ScipioStorage

/// A composite of Cache Storage.
public struct CompositeCacheStorage: CacheStorage {

    private let storages: [any CacheStorage]

    public init(storages: [any CacheStorage]) {
        self.storages = storages
    }

    public func existsValidCache(for cacheKey: some CacheKey) async throws -> Bool {
        for storage in storages {
            guard try await storage.existsValidCache(for: cacheKey) else { continue }
            return true
        }
        return false
    }

    public func fetchArtifacts(for cacheKey: some CacheKey, to destinationDir: URL) async throws {
        for storage in storages {
            guard try await storage.existsValidCache(for: cacheKey) else { continue }
            try await storage.fetchArtifacts(for: cacheKey, to: destinationDir)
            return
        }
    }

    public func cacheFramework(_ frameworkPath: URL, for cacheKey: some CacheKey) async throws {
        for storage in storages {
            guard try await !storage.existsValidCache(for: cacheKey) else { continue }
            try await storage.cacheFramework(frameworkPath, for: cacheKey)
        }
    }
}
