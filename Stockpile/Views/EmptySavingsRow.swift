//
//  EmptySavingsRow.swift
//  Stockpile
//
//  Created by Taylor Young on 2021-09-03.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import SwiftUI

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
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}

struct EmptySavingsRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EmptySavingsRow()
        }
        .listStyle(InsetGroupedListStyle())
            
        List {
            EmptySavingsRow()
        }
        .preferredColorScheme(.dark)
        .listStyle(InsetGroupedListStyle())
    }
}
