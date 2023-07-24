//
//  WordParser.swift
//  Enumerate
//
//  Created by Paul on 23/06/2023.
//

import SwiftUI

struct WordParser: View {
    @Binding var wordList: [WordPair]
    @State private var localText: String = ""
    
    var body: some View {
        List {
            Section {
                TextEditor(text: $localText)
                    .multilineTextAlignment(.leading)
                    .padding(.all)
                    .frame(height: 200)
            } header: {
                Text("Parse new Word List")
            }
        }
        .onChange(of: localText ) { _ in
            var newWordList: [WordPair] = []
            let splitLines = localText.split(separator: "\n")
            
            for item in splitLines {
                let tmp = customSplitter(string: String(item))
                if (tmp.count >= 2) {
                    newWordList.append(WordPair(first: String(tmp[tmp.count-2]), second: String(tmp[tmp.count-1])))
                }
            }
            wordList = newWordList
        }
    }
    
    func customSplitter(string: String) -> [String] {
        var output: [String] = []
        
        let seperators: Set = [" ", ",", ".", "\t", "\n", "\r"]
        
        var tmpString = ""
        
        for c in string {
            if seperators.contains(String(c) ) {
                if tmpString.count != 0 {
                    output.append(tmpString)
                    tmpString = ""
                }
            } else {
                tmpString += String(c)
            }
        }
        if tmpString.count != 0 {
            output.append(tmpString)
        }
        
        return output
    }
}

struct WordParser_Previews: PreviewProvider {
    static var previews: some View {
        WordParser(wordList: .constant([WordPair(first: "", second: ""), WordPair(first: "", second: "")]))
    }
}
