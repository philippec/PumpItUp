//
//  ViewModel.swift
//  PumpItSpy
//
//  Created by Philippe on 2023-05-11.
//

import Foundation
import SwiftUI

@MainActor
class ViewModel: ObservableObject {

    enum LoadError: Error {
        case invalidURL(String)
        case noHTTP
        case badStatus(Int)
    }

    @Published var pumpCycles: [PumpCycle] = []

    func fetchButton(for date: String) {
        Task {
            do {
                let cycles = try await self.fetch(for: date)
                self.pumpCycles = cycles
            } catch {
                print("Oops! \(error)")
            }
        }
    }

    private let authToken = "<insert auth token>"
    private let deviceId = "<insert device id>"


    private func fetch(for date: String) async throws -> [PumpCycle] {
        let urlStr = "http://www.pumpspy.com:8081/pump_outlet_cycles/deviceid/\(deviceId)/date/\(date)"
        guard let url = URL(string: urlStr) else {
            throw LoadError.invalidURL(urlStr)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Origin": "capacitor://localhost",
            "Connection": "keep-alive",
            "Accept": "application/json, text/plain, */*",
            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
            "Authorization": "Bearer \(authToken)",
            "Accept-Language": "fr-CA,fr;q=0.9",
            "Accept-Encoding": "gzip, deflate",
        ]

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw LoadError.noHTTP
        }

        if httpResponse.statusCode != 200 {
            throw LoadError.badStatus(httpResponse.statusCode)
        }

        let result = try JSONDecoder().decode([PumpCycle].self, from: data)

        return result
    }

}

extension ViewModel {

    static var thursday: ViewModel {

        let vm = ViewModel()
        do {
            let result = try JSONDecoder().decode([PumpCycle].self, from: PumpCycle.thursday)
            vm.pumpCycles = result
        } catch {
        }
        return vm
    }
}
