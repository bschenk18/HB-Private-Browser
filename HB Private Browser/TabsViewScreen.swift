import SwiftUI

struct TabsViewScreen: View {
   @Environment(\.presentationMode) var presentationMode
   @ObservedObject var tabsState: TabsViewState
   
   var body: some View {
       VStack {
           List {
               ForEach(tabsState.tabs.indices, id: \.self) { index in
                   Text(tabsState.tabs[index].currentURL ?? "New Tab")
               }
               .onDelete(perform: tabsState.deleteTab)
           }
           
           HStack {
               Button("Done") {
                   presentationMode.wrappedValue.dismiss()
               }
               
               Spacer()
               
               Button(action: {
                   tabsState.addTab()
               }) {
                   Image(systemName: "plus")
               }
               .alert(isPresented: $tabsState.showAlert) {
                   Alert(title: Text("Maximum Tabs Reached"), message: Text("You've reached 10 tabs open at a time limit. Delete existing tabs to open new ones."), dismissButton: .default(Text("OK")))
               }
           }
           .padding()
       }
   }
}
