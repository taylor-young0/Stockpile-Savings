//
//  ContentView.swift
//  Stockpile
//
//  Created by Taylor Young on 2020-05-31.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    LifetimeSavingsRow()
                }
                Section(header: Text("Recent Savings")) {
                    EmptySavingsRow()
                }
            }.navigationBarTitle(Text("Stockpile"))
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing: Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(.blue))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct EmptySavingsRow: View {
    var body: some View {
        VStack {
            HStack() {
                Text("😢 No savings added yet!")
                Spacer()
            }
            HStack {
                Text("Add savings by completing a new calculation by pressing the + icon in the top right")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
}

struct LifetimeSavingsRow: View {
    var body: some View {
        HStack {
            Text("🤑 Lifetime savings")
            Spacer()
            Text("$0.00")
        }
    }
}
