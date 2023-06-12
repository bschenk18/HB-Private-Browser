import Combine
import SwiftUI

class TabsViewState: ObservableObject {
    @Published var tabs: [Tab] = [Tab()]
    @Published var showAlert = false


    func addTab() {
        guard tabs.count < 10 else {
            showAlert = true
            return
        }
        
        let newTab = Tab()
        tabs.append(newTab)
    }
    
    func deleteTab(indexSet: IndexSet) {
        tabs.remove(atOffsets: indexSet)
    }
}
