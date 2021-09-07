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
        EmptySavingsRow()
            .previewLayout(.fixed(width: 375, height: 70))
            .padding(.horizontal)
        
        EmptySavingsRow()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 70))
            .padding(.horizontal)
        
        if #available(iOS 14.0, *) {
            
            // MARK: - iOS 14 Previews
            
            List {
                EmptySavingsRow()
            }
            .listStyle(InsetGroupedListStyle())
            
            List {
                EmptySavingsRow()
            }
            .preferredColorScheme(.dark)
            .listStyle(InsetGroupedListStyle())
        } else {
            
            // MARK: - iOS 13 Previews
            
            List {
                EmptySavingsRow()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            
            List {
                EmptySavingsRow()
            }
            .preferredColorScheme(.dark)
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
    }
}
