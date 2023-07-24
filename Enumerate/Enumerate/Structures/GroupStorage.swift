import Foundation
import SwiftUI

class GroupStorage: ObservableObject {
    @Published var groups: [Group] = []
    var recentNewGroup: Group = Group()
    
    func makeNewGroup() {
        recentNewGroup = Group()
        groups.append(recentNewGroup)
    }
    
    func removeGroupByID(id: UUID) {
        groups.removeAll(where: {$0.id == id})
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("groups.data")
    }
    
    static func deleteItem() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            delete() { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let groupsSaved):
                    continuation.resume(returning: groupsSaved)
                }
            }
        }
    }
    
    static func load() async throws -> [Group] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let groups):
                    continuation.resume(returning: groups)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Group], Error>) ->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let availableGroups = try JSONDecoder().decode([Group].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(availableGroups))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(groups: [Group]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(groups: groups) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let groupsSaved):
                    continuation.resume(returning: groupsSaved)
                }
            }
        }
    }
    
    static func save(groups: [Group], completion: @escaping (Result<Int, Error>)->Void ){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(groups)
                let outFile = try fileURL()
                try data.write(to: outFile)
                DispatchQueue.main.async {
                    completion(.success(groups.count))
                }
                print("Saved")
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                print("Failed")
            }
        }
    }
    
    static func delete(completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let outFile = try fileURL()
                try FileManager.default.removeItem(at: outFile)
                DispatchQueue.main.async {
                    completion(.success(1))
                }
                print("Deleted")
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                print("Failed")
            }
        }
    }
}
