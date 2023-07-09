//
//  HomeView.swift
//  Stockpile
//
//  Created by Taylor Young on 2023-07-08.
//  Copyright © 2023 Taylor Young. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                headerView
                    .padding(.horizontal)
                statsSection
            }
        }
        .background(Color.gray.opacity(0.3))
    }

    var headerView: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Stockpile")
                .font(.title3.bold())

            Spacer(minLength: 0)

            Button {

            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("Stockpile"))
                    .font(.title)
            }
        }
    }

    var statsSection: some View {
        VStack(alignment: .leading) {
            Text("Statistics")
                .font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    StatisticsCard(.lifetimeSavings)
                        .padding(.leading)
                    StatisticsCard(.averagePercentageSavings)
                        .padding(.trailing)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
