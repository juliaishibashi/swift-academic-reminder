import SwiftUI

struct Course: Identifiable {
    let id = UUID()
    let name: String
}

struct CoursesView: View {
    @State private var showAddCourseSheet = false
    @State private var courses: [String: [Course]] = [:]
    
    var body: some View {
        NavigationView {
            VStack {
//                Text("Courses")
//                    .font(.title.bold())
                
                List {
                    ForEach(courses.keys.sorted(), id: \.self) { semester in
                        Section(header: Text(semester).font(.headline)) {
                            ForEach(courses[semester]!, id: \.id) { course in
                                Text(course.name)
                            }
                        }
                    }
                }
                
                Button(action: {
                    showAddCourseSheet = true
                }) {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding()
                }
                .sheet(isPresented: $showAddCourseSheet) {
                    AddCourseView(courses: $courses)
                }
            }
            .navigationTitle("Courses")
        }
    }
}

struct AddCourseView: View {
    @Binding var courses: [String: [Course]]
    @State private var newSemester = ""
    @State private var newCourseName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Semester")) {
                    TextField("Semester Name", text: $newSemester)
                }
                
                Section(header: Text("New Course Name")) {
                    TextField("Course Name", text: $newCourseName)
                }
                
                Button("Add Course") {
                    // Check if both the semester and course name are valid
                    if !newSemester.isEmpty && !newCourseName.isEmpty {
                        // Add the new course to the selected semester
                        let newCourse = Course(name: newCourseName)
                        if courses[newSemester] != nil {
                            courses[newSemester]?.append(newCourse)
                        } else {
                            courses[newSemester] = [newCourse]
                        }
                        newCourseName = ""
                    }
                }
            }
            .navigationBarTitle("Add Course")
        }
    }
}

#Preview {
    CoursesView()
}
