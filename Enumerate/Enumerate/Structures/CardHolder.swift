import Foundation

struct CardHolder: Identifiable {
    let id: Int
    let card: Card
    
    var complete: Bool = false
    var orientation: Bool = false
    
    init(id: Int, card: Card, complete: Bool = false ){
        self.id = id
        self.card = card
        self.complete = complete
        
        if card.type == .TranslateCard {
            self.orientation = Bool.random()
        }
    }
}
