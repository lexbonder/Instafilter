//
//  ContentView.swift
//  Instafilter
//
//  Created by Alex Bonder on 8/19/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    var body: some View {
        VStack {
            Text("Hello, world!")
                .frame(width: 300, height: 300)
                .background(backgroundColor)
                .onTapGesture {
                    showingConfirmation = true
                }
                .confirmationDialog("Change Background", isPresented: $showingConfirmation) {
                    Button("Red") { backgroundColor = .red }
                    Button("Green") { backgroundColor = .green }
                    Button("Blue") { backgroundColor = .blue }
//                    Button("Cancel", role: .cancel) {} // Cancel button added by default
                } message: {
                    Text("Select a new color")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
