//
//  Scoreboard.swift
//  Memorize
//
//  Created by Uri on 8/4/24.
//

import SwiftUI

struct Scoreboard: View {
    
    @ObservedObject var viewModel: MemorojiViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showResetAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    Grid(alignment: .leadingFirstTextBaseline,
                         horizontalSpacing: 20,
                         verticalSpacing: 10) {
                        GridRow {
                            Text("PLAYER")
                            Text("DECK")
                                .gridColumnAlignment(.center)
                            Text("MATCHES")
                                .gridColumnAlignment(.center)
                            Text("SCORE")
                                .gridColumnAlignment(.trailing)
                        }
                        .font(.callout)
                        
                        Divider()
                            .frame(minHeight: 3)
                            .overlay(viewModel.color)
                        
                        ForEach(viewModel.scoreboard.sorted(by: { $0.score > $1.score })) { score in
                            GridRow(alignment: .center) {
                                Text(score.player)
                                Text(score.deck)
                                    .gridColumnAlignment(.center)
                                    .multilineTextAlignment(.center)
                                Text("\(score.matches)")
                                    .gridColumnAlignment(.center)
                                Text("\(score.score)")
                                    .gridColumnAlignment(.trailing)
                            }
                            Divider()
                                .frame(minHeight: 1)
                                .overlay(viewModel.color.opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .alert(isPresented: $showResetAlert) {
                    Alert(
                        title: Text("Reset scoreboard"),
                        message: Text("Do you want to erase the scores saved?"),
                        primaryButton: .default(Text("Discard")),
                        secondaryButton: .destructive(Text("Reset")) { viewModel.resetScoreboard()
                            dismiss()
                        }
                    )
                }
            }
            .navigationTitle("Scoreboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissXButton(customAction: nil)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    resetButton
                }
            }
        }
    }
}

#Preview {
    Scoreboard(viewModel: MemorojiViewModel())
}

extension Scoreboard {
    
    private var resetButton: some View {
        Button(action: {
            showResetAlert = true
        }, label: {
            Image(systemName: "trash")
        })
        .disabled(viewModel.scoreboard.isEmpty)
    }
}


