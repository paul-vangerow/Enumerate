import Foundation

class Card: Identifiable, Hashable {
    let id: UUID
    
    var pair: WordPair
    var type: CardType
    
    init(id: UUID = UUID(), pair: WordPair, type: CardType) {
        self.id = id
        self.pair = pair
        self.type = type
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.pair == rhs.pair &&
               lhs.type == rhs.type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(pair)
        hasher.combine(type)
    }
}

enum CardType: Hashable {
    case FlashCard
    case TranslateCard
}
