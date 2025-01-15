import SwiftUI
import SwiftData

struct AssignmentsView: View {
    @Environment(\.modelContext) private var context
    @Query private var assignment_quiery: [Assignment]
    @Query private var reminder_quiery: [Reminder]
    
    @State private var showAddAssignmentSheet = false
    
    var body: some View {
        VStack {
            Text("Assignments")
                .font(.title.bold())
            
//            Text("Loaded Assignments: \(assignment_quiery.count)")
//            Text("Loaded Reminders: \(reminder_quiery.count)")
//                .padding()
            
            Button(action: {
                showAddAssignmentSheet = true
            }) {
                Spacer()
                Image(systemName: "plus")
                    .font(.system(size: 24))
                    .padding()
            }
            .accessibilityIdentifier("addAssignmentButton")
            
            .sheet(isPresented: $showAddAssignmentSheet) {
                AssignmentRegisterView(showAddAssignmentSheet: $showAddAssignmentSheet)
            }
            
            List {
                ForEach(assignment_quiery.sorted {
                    // "Done" to bottom
                    $0.status == AssignmentStatus.done.rawValue ? false : $1.status == AssignmentStatus.done.rawValue
                }, id: \.id) { assignment in
                    AssignmentsHolderView(assignment: assignment)
                }
            }
        } 
    }
}

#Preview {
    AssignmentsView()
}

