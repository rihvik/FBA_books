//
//  AnalyticsView.swift
//  FBA
//
//  Created by admin on 22/04/24.
//

import SwiftUI
import FirebaseFirestore

struct AnalyticsView: View {
    @State private var genreData: [(String, Int, Int)] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                BarChartView(data: genreData)
                    .padding()
            }
        }
        .onAppear {
            fetchGenreData()
        }
        .navigationBarTitle("Analytics")
    }

    func fetchGenreData() {
        isLoading = true
        let db = Firestore.firestore()
        db.collection("books").getDocuments { querySnapshot, error in
            isLoading = false
            if let error = error {
                errorMessage = "Error fetching documents: \(error.localizedDescription)"
                print(errorMessage)
            } else {
                var genreCountDict: [String: (Int, Int)] = [:] // (issuedCount, availableCount)
                for document in querySnapshot!.documents {
                    let genre = document.get("category") as? String ?? "Unknown"
                    let status = document.get("status") as? String ?? "unknown"
                    if status == "issued" {
                        genreCountDict[genre, default: (0, 0)].0 += 1
                    } else if status == "available" {
                        genreCountDict[genre, default: (0, 0)].1 += 1
                    }
                }
                genreData = genreCountDict.map { ($0.key, $0.value.0, $0.value.1) }
            }
        }
    }
}

struct BarChartView: View {
    var data: [(String, Int, Int)]

    var body: some View {
        VStack {
            Text("Books by Genre")
                .font(.title)
                .padding(.bottom, 20)
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(data, id: \.0) { genre, issuedCount, availableCount in
                        HStack {
                            Text(genre)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            VStack(spacing: 5) {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: CGFloat(issuedCount) * 10, height: 20)
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: CGFloat(availableCount) * 10, height: 20)
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Issued: \(issuedCount)")
                                    .font(.caption)
                                Text("Available: \(availableCount)")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    AnalyticsView()
}
