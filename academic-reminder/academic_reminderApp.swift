import SwiftUI

//@main
//struct academic_reminderApp: App {
//        
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .modelContainer(for: Assignment.self)
//        }
//    }
//}

@main
struct academic_reminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Assignment.self)
        }
    }
}
