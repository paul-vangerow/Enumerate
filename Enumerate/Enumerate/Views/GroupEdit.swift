//
//  RoadEdit.swift
//  Enumerate
//
//  Created by Paul on 19/06/2023.
//

import SwiftUI
import PhotosUI

struct GroupEdit: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var groupStore: GroupStorage
    @ObservedObject var originalGroup: Group
    
    // Configuration Items
    @StateObject private var group: Group = Group()
    @State private var imageItem: PhotosPickerItem?
    
    // Word Parsing & Manipulation
    @State private var newWordPair: WordPair = WordPair(first: "", second: "")
    @State private var showParser: Bool = false
    @State private var newWordList: [WordPair] = []
    
    // Deleting
    @State private var showDeletePopup = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    Label("Title", systemImage: "text.cursor")
                    TextField("Name", text: $group.groupName)
                        .multilineTextAlignment(.trailing)
                    Spacer()
                        .frame(width: 10)
                }
                // ToDo: Fix
                PhotosPicker(selection: $imageItem, matching: .images){
                    HStack {
                        Label("Cover Image", systemImage: "photo")
                        Spacer()
                        ZStack {
                            if let img = group.groupImage {
                                if let uiImg = UIImage(data: img) {
                                    Image(uiImage: uiImg)
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                                else {
                                    Image(systemName: "photo")
                                }
                            } else {
                                Image(systemName: "photo")
                            }
                        }
                        .frame(width: 50, height: 30)
                        Spacer()
                            .frame(width: 10)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } header: {
                Text("Customize")
            }
            Section {
                Button(action: {
                    showParser = true
                }){
                    HStack {
                        Spacer()
                        Text("Parse New Word List")
                        Spacer()
                    }
                }
            } header: {
                Text("Word Pairs")
            }
            Section {
                ForEach($group.wordList) { $word in
                    HStack {
                        TextField("First", text: $word.first)
                            .multilineTextAlignment(.center)
                        Divider()
                        TextField("Second", text: $word.second)
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(width: 30)
                    }
                }
                .onDelete { indices in
                    group.wordList.remove(atOffsets: indices)
                }
                HStack {
                    TextField("First", text: $newWordPair.first)
                        .multilineTextAlignment(.center)
                    Divider()
                    TextField("Second", text: $newWordPair.second)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        withAnimation {
                            group.wordList.append(newWordPair)
                            newWordPair = WordPair(first: "", second: "")
                        }
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    .disabled(!newWordPair.validPair)
                }
            }
            Section {
                Button(action: {
                    showDeletePopup = true
                }){
                    HStack {
                        Spacer()
                        Text("Delete Group")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                .confirmationDialog("Are you Sure?", isPresented: $showDeletePopup, titleVisibility: .visible) {
                    Button("Yes", role: .destructive){
                        self.presentationMode.wrappedValue.dismiss()
                        groupStore.removeGroupByID(id: originalGroup.id)
                    }
                }
            }
        }
        .onChange(of: imageItem){ newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    group.groupImage = data
                    return
                }
                print("Failed")
            }
        }
        .onAppear {
            group.cloneFromGroup(group: originalGroup)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    originalGroup.cloneFromGroup(group: group, createMilestones: true)
                    print(originalGroup.groupName)
                }
                .disabled( group == originalGroup )
            }
        }
        .sheet(isPresented: $showParser) {
            NavigationView {
                WordParser(wordList: $newWordList)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction){
                            Button("Cancel"){
                                showParser = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Parse"){
                                showParser = false
                                group.wordList = newWordList
                            }
                            .disabled(newWordList.isEmpty)
                        }
                    }
            }
        }
    }
}

struct RoadEdit_Previews: PreviewProvider {
    static var previews: some View {
        GroupEdit(originalGroup: Group.PreSpanish )
    }
}
