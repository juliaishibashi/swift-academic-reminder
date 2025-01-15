import SwiftUI
import SwiftData

struct Home: View {
    @State var currentDate: Date = Date()
    @Query private var assignments: [Assignment]
    
    private var assignmentDates: [Date] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return assignments.compactMap { assignment in
            let assignmentDateFormatter = DateFormatter()
            assignmentDateFormatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
            if let assignmentDate = assignmentDateFormatter.date(from: assignment.date) {
                return assignmentDate
            }
            return nil
        }
    }
    
    private var filteredAssignments: [Assignment] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dateFormatter.string(from: currentDate)
        
        let assignmentDateFormatter = DateFormatter()
        assignmentDateFormatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
        
        return assignments.filter { assignment in
            if let assignmentDate = assignmentDateFormatter.date(from: assignment.date) {
                let assignmentDateString = dateFormatter.string(from: assignmentDate)
                return assignmentDateString == currentDateString
            }
            return false
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                DatePickerView(currentDate: $currentDate, assignmentDates: assignmentDates)

                VStack {
                    ForEach(filteredAssignments, id: \.id) { assignment in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(assignment.title)
                                .font(.headline)
                            Text("Due: \(assignment.date)")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .frame(width: 350)
                .padding(.top, 5)
            }
        }
    }
}

#Preview {
    Home()
}
