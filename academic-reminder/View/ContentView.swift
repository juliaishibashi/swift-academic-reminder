//
//  ContentView.swift
//  academic-reminder
//
//  Created by Julia on 2024-11-26.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            AssignmentsView()
                .tabItem {
                    Label("Assignments", systemImage: "book.pages")
                }
            
            GradesView()
                .tabItem {
                    Label("Grades", systemImage: "checkmark.square.fill")
                }
            CoursesView()
                .tabItem {
                    Label("Courses", systemImage: "graduationcap")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
