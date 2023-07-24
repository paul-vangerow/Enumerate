import Foundation

struct WordPair: Identifiable, Encodable, Decodable {
    let id: UUID
    
    var first: String
    var second: String
    
    var validPair: Bool {
        return first != "" && second != ""
    }
    
    init(id: UUID = UUID(), first: String, second: String) {
        self.id = id
        self.first = first
        self.second = second
    }
}

extension WordPair: Equatable {
    static func == (lhs: WordPair, rhs: WordPair) -> Bool {
        return lhs.first  == rhs.first &&
               lhs.second == rhs.second
    }
}

extension WordPair: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(first)
        hasher.combine(second)
    }
}
