//
//  ContentView.swift
//  PumpItSpy
//
//  Created by Philippe on 2023-05-11.
//

import SwiftUI
import Charts

struct ContentView: View {

    @ObservedObject var viewModel: ViewModel
    @State var date: String = "2023-05-10"

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            TextField("Date", text: $date)
                .padding()
            Button("Get pump data") {
                viewModel.fetchButton(for: date)
            }
            .padding()
            Spacer()
            Chart(viewModel.pumpCycles) { pumpCycle in
                PointMark(
                    x: .value("Date", pumpCycle.date_time),
                    y: .value("Gallons", pumpCycle.gallons))
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static let viewModel = ViewModel.thursday
    static var previews: some View {
        ContentView(viewModel: viewModel)
    }
}
