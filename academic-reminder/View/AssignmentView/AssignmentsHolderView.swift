import SwiftUI
import SwiftData

enum AssignmentStatus: String {
    case notStarted = "Not started"
    case inProgress = "In progress"
    case done = "Done"
}

struct AssignmentsHolderView: View {
    @Environment(\.modelContext) private var context
    @Query private var assignment_quiery: [Assignment]
    @Query private var reminder_quiery: [Reminder]
    
    var assignment: Assignment
    var onStatusChanged: (() -> Void)?
    
    @State private var currentStatus: String
    
    
    init(assignment: Assignment, onStatusChanged: (() -> Void)? = nil) {
        self.assignment = assignment
        self.onStatusChanged = onStatusChanged
        _currentStatus = State(initialValue: assignment.status.isEmpty ? "Status" : assignment.status)
    }
    
    //for Assignment to AssignmentStatus
    private func updateStatus(for assignment: Assignment, to status: AssignmentStatus) {
        //        let oldStatus = assignment.status
        
        assignment.status = status.rawValue
        currentStatus = status.rawValue
        
        context.insert(assignment)
        saveAssignment()
        onStatusChanged?()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 350, height: 100)
                .foregroundColor(currentStatus == AssignmentStatus.done.rawValue ? Color.gray.opacity(0.2) : Color(red: 1.0, green: 1.0, blue: 0.8))
            
            VStack {
                HStack {
                    Text(assignment.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.semibold)
                    
                    Menu {
                        Button(action: {
                            updateStatus(for: assignment, to: AssignmentStatus.notStarted)
                        }) {
                            Text("Not started")
                        }
                        Button(action: {
                            updateStatus(for: assignment, to: .inProgress)
                        }) {
                            Text("In progress")
                        }
                        Button(action: {
                            updateStatus(for: assignment, to: .done)
                        }) {
                            Text("Done")
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(height: 32)
                            //status options
                            HStack {
                                Text(currentStatus)
                                    .padding(.leading, 10)
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                Text(assignment.type + " (" + assignment.weight + " %) - " + assignment.courseName)
                Text("Due: \(assignment.date)")
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                deleteAssignment(assignment)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
    
    private func deleteAssignment(_ assignment: Assignment) {
        for reminder in assignment.children {
            reminder.parent = nil
            context.delete(reminder)
        }
        context.delete(assignment)
        saveAssignment()
    }
    
//    private func deleteAllreminders(_ assignment: Assignment) {
//        for reminder in reminder_quiery {
//            context.delete(reminder)
//        }
//        context.delete(assignment)
//        saveAssignment()
//    }
    
    private func saveAssignment(){
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        printRemainingData()
    }
    
    private func printRemainingData() {
        print("Total # of assignments: \(assignment_quiery.count)")
        print("Total # of reminder_quiery: \(reminder_quiery.count)")
        
//        for reminder in reminder_quiery {
//            print("Reminder ID: \(reminder.id), Value: \(reminder.remindValue), Option: \(reminder.selectedOption)")
//        }
        
        for assignment in assignment_quiery {
            print("Assignment ID: \(assignment.id), Title: \(assignment.title), Course: \(assignment.courseName), Type: \(assignment.type), Weight: \(assignment.weight), Due Date: \(assignment.date)")
            
            for reminder in assignment.children {
                print("  - Reminder ID: \(reminder.id), Value: \(reminder.remindValue), Option: \(reminder.selectedOption)")
            }
        }
    }
}

