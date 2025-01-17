//
//  ContentView.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel()
    @State private var path: [DeviceData] = [] // Navigation path
    @State private var searchData: String = "Search Device Details"

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if let computers = viewModel.data, !computers.isEmpty {
                    DevicesList(devices: computers) { selectedComputer in
                        viewModel.navigateToDetail(navigateDetail: selectedComputer)
                    }
                } else {
                    ProgressView("Loading...")
                        .onAppear() {
                            viewModel.fetchAPI()
                        }
                }
            }
            .onChange(of: viewModel.navigateDetail, {
                let navigate = viewModel.navigateDetail
                path.append(navigate!)
            })
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceData.self) { computer in
                DetailView(device: computer)
            }
            .searchable(text: $searchData)
            .onAppear {
                viewModel.fetchAPI()
            }
        }
    }
}
