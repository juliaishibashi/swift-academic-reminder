import SwiftUI
import UserNotifications
import SwiftData

struct NotificationManager {
    
    @Environment(\.modelContext) private var context
    @Query private var assignment_quiery: [Assignment]
    
    func scheduleNotification(for assignment: Assignment, with reminder: Reminder) {
        // Step 1: Parse the assignment date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
                
        guard let deadlineDate = dateFormatter.date(from: assignment.date) else {
            print("Invalid date format. Received: \(assignment.date)")
            return
        }
        // Step 2: Convert remindValue to Int
        guard let remindValueInt = Int(reminder.remindValue) else {
            print("Invalid remindValue format: \(reminder.remindValue)")
            return
        }
        
        // Step 3: Calculate the notification date
        var notificationDate = deadlineDate
        switch reminder.selectedOption {
            //when notificationDate is nil just return deadlineDate
        case "Minutes":
            notificationDate = Calendar.current.date(byAdding: .minute, value: -remindValueInt, to: deadlineDate) ?? deadlineDate
        case "Hours":
            notificationDate = Calendar.current.date(byAdding: .hour, value: -remindValueInt, to: deadlineDate) ?? deadlineDate
        case "Days":
            notificationDate = Calendar.current.date(byAdding: .day, value: -remindValueInt, to: deadlineDate) ?? deadlineDate
        case "Weeks":
            notificationDate = Calendar.current.date(byAdding: .weekOfYear, value: -remindValueInt, to: deadlineDate) ?? deadlineDate
        default:
            print("Invalid reminder option")
            return
        }
        print("Reminder value: \(remindValueInt)")
        print("Deadline Date: \(deadlineDate)")
        print("Calculated notification date: \(notificationDate)")
        
        // Step 4: Schedule the local notification
        let content = UNMutableNotificationContent()
        content.title = "Assignment Reminder"
        content.body = "\(assignment.title) is due on \(assignment.date)."
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(notificationDate)")
            }
        }
    }
    
    // Step 5: Loop through assignments and reminders to schedule notifications
    func scheduleNotificationsForAllAssignments() {
        for assignment in assignment_quiery {
            for reminder in assignment.children {
                scheduleNotification(for: assignment, with: reminder)
            }
        }
    }
}
