import Foundation
import SwiftData

@Model
final class Assignment{
    var id: UUID
    var title: String
    var courseName: String
    var type: String
    var weight: String
    var date: String
    var status: String

    @Relationship(inverse: \Reminder.parent)
    var children: [Reminder] = []

    init(title: String, courseName: String, type: String, weight: String, date: String, status: String, children: [Reminder] = []) {
        self.id = UUID()
        self.title = title
        self.courseName = courseName
        self.type = type
        self.weight = weight
        self.date = date
        self.status = status
        self.children = children
    }
}
