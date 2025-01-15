import SwiftUI
import SwiftData

// Utility to get formatted date
func getFormattedDate(from date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

// Utility to get the start of the month
func startOfMonth(for date: Date) -> Date {
    let calendar = Calendar.current
    return calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
}

// Utility to calculate padding
func calculatePadding(for firstWeekday: Int, calendar: Calendar) -> Int {
    (firstWeekday - calendar.firstWeekday + 7) % 7
}

struct DatePickerView: View {
    @Binding var currentDate: Date
    @State private var currentMonth: Int = 0
    var assignmentDates: [Date]
//    @Query private var assignments: [Assignment]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color(red: 1.0, green: 1.0, blue: 0.8))
                .frame(width: 350, height: 420)
            
            VStack {
                CalendarHeader(currentMonth: $currentMonth)
                    .frame(height: 50)
                    .padding(.horizontal)
                
                DayOfWeekRow()
                    .frame(height: 30)
                    .padding(.horizontal)
                
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(extractDate(), id: \.id) { value in
                        DateCardView(value: value, selectedDate: $currentDate, assignmentDates: assignmentDates)
                            .onTapGesture {
                                if value.day != 0 {
                                    currentDate = value.date
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        guard let currentMonthDate = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return []
        }
        
        let firstDayOfMonth = startOfMonth(for: currentMonthDate)
        let range = calendar.range(of: .day, in: .month, for: currentMonthDate)!
        var dates: [DateValue] = []
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysToPad = calculatePadding(for: firstWeekday, calendar: calendar)
        
        for _ in 0..<daysToPad {
            dates.append(DateValue(day: 0, date: Date.distantFuture))
        }
        
        for day in 1...range.count {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            dates.append(DateValue(day: day, date: date))
        }
        
        return dates
    }
}

struct CalendarHeader: View {
    @Binding var currentMonth: Int
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                currentMonth -= 1
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text(getFormattedDate(from: getCurrentMonthDate(), format: "MMMM yyyy"))
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
            
            Spacer()
            
            Button(action: {
                currentMonth += 1
            }) {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
            }
        }
    }
    
    private func getCurrentMonthDate() -> Date {
        Calendar.current.date(byAdding: .month, value: currentMonth, to: Date()) ?? Date()
    }
}

struct DayOfWeekRow: View {
    let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(days, id: \.self) { day in
                Text(day)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
    }
}

struct DateCardView: View {
    let value: DateValue
    @Binding var selectedDate: Date
    var assignmentDates: [Date]
    
    var body: some View {
        if value.day != 0 {
            Text("\(value.day)")
                .font(.title3.bold())
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(
                    Calendar.current.isDate(value.date, equalTo: Date(), toGranularity: .day) ? Color.orange.opacity(0.5)
                    : Color.clear
                )
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            value.date == selectedDate ? Color.gray : Color.clear,
                            lineWidth: 2
                        )
                )
                .overlay(
                    Rectangle()
                        .frame(width: 18, height: 2)
                        .foregroundColor(assignmentDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: value.date) }) ? .gray : .clear)
                        .padding(.top, 25)
                )

                .onTapGesture {
                    selectedDate = value.date
                    print("Date selected: \(formatDate(selectedDate))")
                }
        } else {
            Color.clear
                .frame(height: 40)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        let assignmentDates: [Date] = [
            Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 12))!
        ]
        DatePickerView(currentDate: .constant(Date()), assignmentDates: assignmentDates)
                   .previewDisplayName("Default Preview")
               
       // Custom Date Preview (e.g., a specific date or month)
       DatePickerView(currentDate: .constant(Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 15))!),
                      assignmentDates: assignmentDates)
           .previewDisplayName("Custom Date Preview")
   }
}
