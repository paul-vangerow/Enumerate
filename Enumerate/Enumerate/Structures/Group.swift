import Foundation
import SwiftUI

class Group: ObservableObject, Identifiable {
    var id: UUID
    
// Customization
    @Published var groupName: String
    @Published var groupImage: Data?
    
// Functionality
    @Published var wordList: [WordPair]
    var completedCards: Int = 0 {
        didSet {
            for item in milestones {
                item.currentCardsComplete = completedCards
            }
            print(completedCards)
        }
    }
    
    var translateCards: [Card] = []
    var flashCards: [Card] = []
    var milestones: [Milestone] = []
    
    var seed: UInt64
    var generator: SplitMix64
    
// Initialisers
    
    // COMPLETE INITIALISER
    init(id: UUID = UUID(), groupName: String, groupImage: Data?, wordList: [WordPair], completedCards: Int, seed: UInt64) {
        self.id = id
        self.groupName = groupName
        self.groupImage = groupImage
        self.wordList = wordList
        self.completedCards = completedCards
        self.seed = seed
        
        generator = SplitMix64(seed: seed )
        
        requestItems(words: wordList)
    }
    
    // NEW GROUP INITIALISER
    init() {
        self.id = UUID()
        self.groupName = "New Group"
        self.wordList = []
        self.completedCards = 0
        self.seed = UInt64.random(in: 0...UINT64_MAX)
        self.generator = SplitMix64(seed: seed)
    }
    
    // DECODE INITIALISER
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        groupName = try values.decode(String.self, forKey: .groupName)
        groupImage = try values.decode(Data.self, forKey: .groupImage)
        wordList = try values.decode([WordPair].self, forKey: .wordList)
        completedCards = try values.decode(Int.self, forKey: .completedCards)
        seed = try values.decode(UInt64.self, forKey: .seed)
        
        generator = SplitMix64(seed: seed)
        
        requestItems(words: wordList)
    }
}

// ---------------- FUNCTIONS ----------------

extension Group {
    
        /* ----- RequestItems -----
            input - [WordPair]
            returns - Nothing
         
            Functionality: Call createCards and createMilestones for:
                            - A Group being loaded on Startup
                            - A Group's 'WordList' being modified
         */

    func requestItems( words: [WordPair] ){
        (flashCards, translateCards) = createCards(words: words)
        milestones = createMilestones(flashCards: flashCards)
    }
    
        /* ----- CreateCards -----
            input - [WordPair]
            returns - ([Card], [Card])
         
            Functionality: Create a FLASHCARD and TRANSLATECARD object for each 'WordPair'
                           found in wordList. FlashCard ID = EVEN, TranslateCard ID = ODD.
         */

    func createCards( words: [WordPair]) -> ([Card], [Card]){
        if ( words.count == 0 ) {
            print("[WARNING] Attempting to create cards with an empty WordList")
        }
        
        var translate: [Card] = []
        var flash: [Card] = []
        
        for pairs in words {
            translate.append( Card(pair: pairs, type: .TranslateCard) )
            flash.append( Card(pair: pairs, type: .FlashCard) )
        }
        
        if translate.count + flash.count != 2 * words.count {
            print("Something went wrong. Created: ", translate.count, "t + ", flash.count, "f from ", 2 * words.count)
        }
        
        return (flash, translate)
    }
    
        /* ----- CreateMilestones -----
            input - [Card]
            returns - [Milestone]
         
            Functionality: Create a MILESTONE object for every 10 flashcards with a reference
                           to its length, and during which 'completedCards' period it should
                           expect to exist.
         */

    func createMilestones( flashCards: [Card] ) -> [Milestone] {
        if ( flashCards.count == 0 ){
            print("[WARNING] Attempting to create milestones with an empty FlashCardList")
        }
        
        var milestones: [Milestone] = []
        var startValue: Int = 0
        var lengthValue: Int = 20
        
        for idx in 0..<( ((flashCards.count - 1) / 10) + 1 ) {
            let slice = Array(flashCards[ (idx * 10)..<min( ((idx + 1) * 10), flashCards.count ) ])
            
            milestones.append( Milestone(id: idx, cardStartValue: startValue, cardSizeValue: lengthValue, cards: slice, syncCards: updateCardsComplete, cardRequest: requestCards, completedCards: completedCards ))
            
            startValue += lengthValue
            lengthValue += 10
        }
        
        return milestones
    }

        /* ----- CloneFromGroup -----
            input - Group, Bool
            returns - Nothing
         
            Functionality: Copies all relevant elements of another Group should they be
                           different. CreateMilestones property can be used to additionally
                           generate all the Cards and Milestones that may result from the
                           specific changes.
         */

    func cloneFromGroup( group: Group, createMilestones: Bool = false ){
        if groupName != group.groupName {
            groupName = group.groupName
        }
        if groupImage != group.groupImage {
            groupImage = group.groupImage
        }
        if wordList != group.wordList {
            wordList = group.wordList
            completedCards = 0
            if createMilestones {
                requestItems(words: wordList)
            }
        }
    }
    
        /* ----- RequestCards -----
            input - Int
            returns - [Card]
         
            Functionality: Returns a Shuffled List of TRANSLATE CARDS based on the
                           number requested.
         */
    
    func requestCards(numberOfCards: Int) -> [Card] {
        return Array( translateCards[0..<min(numberOfCards, translateCards.count)] ).shuffled(using: &generator)
    }
    
    /* ----- ResetGroup -----
        input - Nothing
        returns - Nothing
     
        Functionality: Resets all values on the Group Object
     */

    func updateCardsComplete(value: Int){
        completedCards = value
    }
    
}

// ---------- PROTOCOL CONFORMANCE ----------

// EQUATABLE
extension Group: Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.completedCards == rhs.completedCards &&
               lhs.groupName      == rhs.groupName      &&
               lhs.groupImage     == rhs.groupImage     &&
               lhs.wordList       == rhs.wordList
    }
}

// HASHABLE
extension Group: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(groupName)
        hasher.combine(groupImage)
        hasher.combine(wordList)
        hasher.combine(completedCards)
        hasher.combine(seed)
    }
}

// CODABLE
extension Group: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName
        case groupImage
        case wordList
        case completedCards
        case seed
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(groupName, forKey: .groupName)
        try container.encode(groupImage, forKey: .groupImage)
        try container.encode(wordList, forKey: .wordList)
        try container.encode(completedCards, forKey: .completedCards)
        try container.encode(seed, forKey: .seed)
    }
}

// ---------- PRELOADED DATA ----------
extension Group {
    
    static let sample_wordlist_spanish: [WordPair] = [
        WordPair(first: "Como",    second: "As"   ), WordPair(first: "Yo",       second: "I"    ),
        WordPair(first: "Su",      second: "His"  ), WordPair(first: "Que",      second: "That" ),
        WordPair(first: "Como",    second: "As"   ), WordPair(first: "Él",       second: "He"   ),
        WordPair(first: "Era",     second: "Was"  ), WordPair(first: "Para",     second: "For"  ),
        WordPair(first: "En",      second: "On"   ), WordPair(first: "Son",      second: "Are"  ),
        WordPair(first: "Con",     second: "With" ), WordPair(first: "Ellos",    second: "They" ),
        WordPair(first: "Ser",     second: "Be"   ), WordPair(first: "En",       second: "At"   ),
        WordPair(first: "Uno",     second: "One"  ), WordPair(first: "Tener",    second: "Have" ),
        WordPair(first: "Este",    second: "This" ), WordPair(first: "Desde",    second: "From" ),
        WordPair(first: "Por",     second: "By"   ), WordPair(first: "Caliente", second: "Hot"  ),
        WordPair(first: "Palabra", second: "Word" )
    ]
    
    static let imageData: Data? = UIImage(named: "SpainPlaceholder")!.pngData()
    
    static let PreSpanish = Group(groupName: "Spanish", groupImage: imageData, wordList: sample_wordlist_spanish, completedCards: 0, seed: 1)
}
