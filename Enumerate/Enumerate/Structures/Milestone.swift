import Foundation
import SwiftUI

class Milestone: Identifiable, ObservableObject {
    let id: Int
    let requestCards: (_: Int) -> [Card]
    
    let syncCards: ( _: Int ) -> Void
    
    // Progress Tracking
    let cardStartValue: Int
    let cardSizeValue: Int
    @Published var currentCardsComplete: Int
    
    var milestoneState: ProgressState {
        if currentCardsComplete >= (cardStartValue + cardSizeValue) {
            if ( cards.count > min(cardSizeValue, 10) ) {
                clearTranslation()
            }
            return .DONE
        } else if currentCardsComplete < cardStartValue {
            return .UNAVAILABLE
        } else {
            if ( cards.count <= 10 ) {
                addCards(newCards: requestCards(cardSizeValue - cards.count), startVal: cards.count, localCompletion: (currentCardsComplete - cardStartValue) )
            }
            return .PROGRESS
        }
    }
    
    // Card Value Tracking
    var cards: [CardHolder]
    
    var localCardCompletion: Int {
        switch milestoneState {
            case .PROGRESS       : return self.currentCardsComplete - self.cardStartValue
            case .DONE           : return self.cardSizeValue
            case .UNAVAILABLE    : return 0
        }
    }
    
    init(id: Int, cardStartValue: Int, cardSizeValue: Int, cards: [Card], syncCards: @escaping ( _:Int ) -> Void, cardRequest: @escaping ( _: Int) -> [Card], completedCards: Int) {
        self.id = id
        self.cardStartValue = cardStartValue
        self.cardSizeValue = cardSizeValue
        self.currentCardsComplete = completedCards
        self.requestCards = cardRequest
        self.syncCards = syncCards
        self.cards = []
        
        addCards(newCards: cards, startVal: 0, localCompletion: (completedCards - cardStartValue) )
    }
}

// ---------------- FUNCTIONS ----------------

extension Milestone {
    
        /* ----- ClearTranslation -----
            input - Nothing
            returns - Nothing
         
            Functionality: Removes all Translate Cards from the Milestone ( Occurs when Completed )
         */

    func clearTranslation() {
        cards.removeAll(where: { $0.card.type == .TranslateCard })
    }
    
        /* ----- AddCards -----
            input - [Card]
            returns - Nothing
         
            Functionality: Adds Cards to the Milestone
         */
    
    func addCards( newCards: [Card], startVal: Int , localCompletion: Int) {
        var tmpID = startVal
        for tmpcard in newCards {
            cards.append( CardHolder(id: tmpID, card: tmpcard, complete: (tmpID < localCompletion) ) )
            tmpID += 1
        }
    }
    
    /* ----- CompleteCard -----
        input - Nothing
        returns - Nothing
     
        Functionality: Increments the total number of Completed Cards
     */
    
    func completeCard(cardID: Int) {
        if cards[cardID].complete == false {
            syncCards( currentCardsComplete + 1 )
            cards[cardID].complete = true
        }
    }
}

enum ProgressState {
    case DONE
    case PROGRESS
    case UNAVAILABLE
}
