import SwiftUI

struct MainView: View {
    @EnvironmentObject var groupStore: GroupStorage

    @State private var isEditingNewGroup: Bool = false
    @State private var accessGroup: Bool = false;
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                VStack {
                    ScrollView(showsIndicators: false) {
                        HSpacer(height: 50)
                        HeadingText(text: "Quantify", size: 50)
                        HSpacer(height: 50)
                        ForEach(groupStore.groups) { group in
                            VStack {
                                WrapperGroupView(groupToPresent: group)
                                HSpacer(height: 30)
                            }
                        }
                        HSpacer(height: 20)
                        
                        Button(action: {
                            groupStore.makeNewGroup()
                            isEditingNewGroup = true
                        } ){
                            HStack {
                                HeadingText(text: "Add New", size: 20)
                                    .fontWeight(.light)
                                Image(systemName: "plus.circle")
                                    .foregroundColor(Color("StandardBGText"))
                            }
                        }
                        .navigationDestination(isPresented: $isEditingNewGroup) {
                            GroupEdit(originalGroup: groupStore.recentNewGroup )
                                .onDisappear {
                                    isEditingNewGroup = false
                                }
                        }
                    }
                    Spacer()
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                Task {
                    do {
                        try await GroupStorage.save(groups: groupStore.groups)
                    } catch {
                        print("Something went wrong..")
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject( GroupStorage() )
    }
}
