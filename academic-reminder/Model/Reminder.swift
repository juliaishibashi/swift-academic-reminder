import Foundation
import SwiftData

@Model
final class Reminder: Hashable{
    
    @Attribute(.unique)
    var id: UUID
    var remindValue: String
    var selectedOption: String
    
    var parent: Assignment?
    
    init(remindValue: String, selectedOption: String) {
        self.id = UUID()
        self.remindValue = remindValue
        self.selectedOption = selectedOption
    }
}
