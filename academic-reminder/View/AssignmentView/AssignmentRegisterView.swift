import SwiftUI
import SwiftData

struct AssignmentRegisterView: View {
    
    @Environment(\.modelContext) private var context

    @Binding var showAddAssignmentSheet: Bool
    
    @State private var newAssignmentName: String = ""
    @State private var newCourseName: String = ""
    @State private var selectedType: String = ""
    @State private var newWeight: String = ""
    
    // Add NotificationManager instance
    private let notificationManager = NotificationManager()
    
    //error handring for weight
    @State private var weightError: String?
    
    //initialized due time as 23:59
    @State private var date: Date = {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 23
        components.minute = 59
        return calendar.date(from: components) ?? Date()
    }()
    
    @State private var selectedDate: String = ""
    @State private var showAddReminderSheet: Bool = false
    
    @State private var reminders: [Reminder] = []
        
    init(showAddAssignmentSheet: Binding<Bool>) {
        self._showAddAssignmentSheet = showAddAssignmentSheet
    }
    
    var body: some View {
        VStack{
            Text("Assignments")
                .font(.title.bold())
            
            HStack {
                Text("Title:")
                TextField("Enter assignment title", text: $newAssignmentName)
                    .padding()
            }//assignment title
            .onChange(of: newAssignmentName) { oldName, newName in
                print("SELECTED NAME: \(newAssignmentName)")
            }//onChange
            
            HStack {
                Text("Course:")
                TextField("Course", text: $newCourseName)
                    .padding()
            } // course
            .onChange(of: newCourseName) { oldName, newName in
                print("COURSE NAME: \(newCourseName)")
            }//onChange
            
            HStack {
                Text("Type:")
                Menu {
                    Button(action: {
                        selectedType = "Assignment"
                    }) {
                        Text("Assignment")
                    }
                    
                    Button(action: {
                        selectedType = "Quiz"
                    }) {
                        Text("Quiz")
                    }
                    
                    Button(action: {
                        selectedType = "Exam"
                    }) {
                        Text("Exam")
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(height: 32)
                        
                        HStack {
                            Text(selectedType)
                            Spacer()
                            Image(systemName: "arrowtriangle.down.fill")
                                .padding(.trailing, 10)
                        }.accessibilityIdentifier("arrowtriangleType")
                    }
                }
                
                .padding()
            } //h
            .onChange(of: selectedType) { oldType, newType in
                print("COURSE TYPE: \(selectedType)")
            }//onChange
            
            HStack {
                Text("Weight:")
                TextField("Enter Weight", text: $newWeight)
                    .padding()
                    .keyboardType(.numberPad)
            }//weight
            .onChange(of: newWeight) { oldValue, newValue in
                print("COURSE WEIGHT: \(newWeight)")
                if let _ = Int32(newValue) {
                    weightError = nil
                } else {
                    weightError = "Please enter a valid integer value"
                }
            }//onChange
            
            .overlay(
                Group {
                    if let weightError = weightError {
                        Text(weightError)
                            .padding()
                            .foregroundColor(.red)
                    }
                },
                alignment: .topTrailing
            ) //error msg
            
            VStack {
                DatePicker(
                    "Due Date: ",
                    selection: $date,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .onChange(of: date) { oldDate, newDate in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .short
                    selectedDate = dateFormatter.string(from: newDate)
                    print("SELECTED DATE: \(selectedDate)")
                } //onChange
                .padding()
            }//due date
            
            HStack {
                Text("Reminder: ")
                Button(action: {
                    showAddReminderSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                }
                .padding()
                .sheet(isPresented: $showAddReminderSheet) {
                    ReminderView(showAddReminderSheet: $showAddReminderSheet, reminders: $reminders)
                }
            } //reminder
//            ForEach(reminders, id: \.self) { reminder in
//                Text(" Reminders: \(reminder.remindValue)\(reminder.selectedOption)")
//            }

            Button(action: {
                let finalDate = date == Date() ? Date() : date
                //create and save the assignmnet to the context
                let newAssignemt = Assignment(
                    title: newAssignmentName,
                    courseName: newCourseName,
                    type: selectedType,
                    weight: newWeight,
                    date: selectedDate.isEmpty ? DateFormatter.localizedString(from: finalDate, dateStyle: .medium, timeStyle: .short) : selectedDate,
                    status: ""
                )
                
                for reminder in reminders {
                    let newReminder = Reminder(remindValue: reminder.remindValue, selectedOption: reminder.selectedOption)
                    newReminder.parent = newAssignemt
                    newAssignemt.children.append(newReminder)
                    
                    context.insert(newReminder)
                    context.insert(newAssignemt)

                    
                    print("REMINDER - Saving reminder with value: \(newReminder.id), \(newReminder.remindValue), option: \(newReminder.selectedOption), assigned to Assignment ID: \(newAssignemt.id)")
                    
                }
                                
                print("ASSIGNMENT - Saving new assignment: \(newAssignemt.id), Title: \(newAssignemt.title), Course: \(newAssignemt.courseName), Type: \(newAssignemt.type), Weight: \(newAssignemt.weight), Due Date: \(newAssignemt.date)")

                do {
                    try context.save()
                    print("Assignment saved")
                } catch {
                    print("Error on AssignmentRegisterView: \(error.localizedDescription)")
                }
                for reminder in reminders{
                    notificationManager.scheduleNotification(for: newAssignemt, with: reminder)
                }
                showAddAssignmentSheet = false
            }) {
                Text("Save")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .accessibilityIdentifier("assignmentSave")
        }// Whole vstack
        .foregroundColor(.black)
        .padding(.leading, 15)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
//    
//    private func scheduleNotification(for assignment: Assignment, with reminder: Reminder) {
//        
//        print("Debug: Assignment we got: \(assignment.title)")
//        print("Debug: Reminder val we got: \(reminder.remindValue)")
//        
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            print("Debug: Assignment Title: \(assignment.title)")
//            print("Debug: Reminder Value: \(reminder.remindValue)")
//            appDelegate.scheduleNotification(for: assignment, with: reminder)
//        } else {
//            print("Error: Unable to retrieve AppDelegate.")
//        }
//    }
}

struct AssignmentRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentRegisterView(showAddAssignmentSheet: .constant(false))
            .modelContainer(for: Assignment.self)
    }
}
