import SwiftUI
import Foundation

struct ReminderView: View {
    @Binding var showAddReminderSheet: Bool
    @Binding var reminders: [Reminder]
    
    @State private var newReminderValue: String = ""
    @State private var newSelectedOption: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Reminder: ")
                Button(action: {
                    let newReminder = Reminder(remindValue: newReminderValue, selectedOption: newSelectedOption)
                    reminders.append(newReminder)
                    
                }) {
                    Image(systemName: "plus.circle.fill")
                }
                .accessibilityIdentifier("addReminderButton")

                Spacer()
            }
            .padding()
            
            ForEach(reminders.indices, id: \.self) { index in
                AddReminderView(currentReminder: $reminders[index], reminders: $reminders)
                    .id(index)
            }

            // Save button
            Button(action: {
                for reminder in reminders {
                    print("Checking reminder with value: \(reminder.remindValue) and option: \(reminder.selectedOption)")
                }
                showAddReminderSheet = false
            }) {
                Text("Save")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }.accessibilityIdentifier("reminderSave")
            Text("Reminder Values: \(reminders.map { "\($0.remindValue) \($0.selectedOption)" }.joined(separator: ", "))")

            }
        }

    struct AddReminderView: View {
        @Binding var currentReminder: Reminder
        @Binding var reminders: [Reminder]

        var body: some View {
            HStack {
                VStack {
                    HStack {
                        Text("Remind: ")
                        TextField("Input integer", text: $currentReminder.remindValue)
                            .frame(width: 50, height: 32)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Menu {
                            Button(action: {
                                currentReminder.selectedOption = "Minutes"
                            }) {
                                Text("Minutes")
                            }
                            Button(action: {
                                currentReminder.selectedOption = "Hours"
                            }) {
                                Text("Hours")
                            }
                            Button(action: {
                                currentReminder.selectedOption = "Days"
                            }) {
                                Text("Days")
                            }
                            Button(action: {
                                currentReminder.selectedOption = "Weeks"
                            }) {
                                Text("Weeks").fixedSize()
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 100, height: 32)
                                
                                HStack {
                                    Text(currentReminder.selectedOption)
                                        .frame(maxWidth: 100, alignment: .leading)
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .padding(.trailing, 10)
                                }
                                .accessibilityIdentifier("reminderArrowDownButton")

                            }
                        }
                        Text(" Before")
                            .padding()
                    }
                    .fixedSize()
                }
                Button(action: {
                    reminders = reminders.filter { $0.id != currentReminder.id }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(showAddReminderSheet: .constant(false), reminders: .constant([]))
    }
}
