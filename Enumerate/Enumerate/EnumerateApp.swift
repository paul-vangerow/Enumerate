//
//  EnumerateApp.swift
//  Enumerate
//
//  Created by Paul on 24/07/2023.
//

import SwiftUI

@main
struct EnumerateApp: App {
    @StateObject var centralGroupStore: GroupStorage = GroupStorage()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(centralGroupStore)
                .task {
                    do {
                        centralGroupStore.groups = try await GroupStorage.load()
                    } catch {
                        print("An error has occured. Deleting defunct data...")
                        do {
                            let out = try await GroupStorage.deleteItem()
                            print(out)
                        } catch {
                            print("Deleting failed.")
                        }
                    }
                }
        }
    }
}
