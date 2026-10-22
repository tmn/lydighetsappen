//
//  Fot.swift
//  lydighetsappen
//
//  Created by Tri Nguyen on 22/10/2026.
//

import SwiftUI

enum CommandSpeed: String {
    case slow, normal, intensive
    var id: Self { self }
}

/// Kommandoer som kan brukes i lineføring i konkurranselydighet (LP).
enum FotCommand: String, CaseIterable, Identifiable {
    case forwardMarch
    case halt
    case rightTurn
    case leftTurn
    case aboutTurn
    case slowMarch
    case normalMarch
    case runMarch
    case aboutTurnAndHalt

    var id: Self { self }

    var title: String {
        switch self {
        case .forwardMarch: "Fremmad - marsj"
        case .halt: "Gjør holdt"
        case .rightTurn: "Høyre - om"
        case .leftTurn: "Venstre - om"
        case .aboutTurn: "Helt - om"
        case .slowMarch: "Sakte marsj"
        case .normalMarch: "Vanlig marsj"
        case .runMarch: "Springmarsj"
        case .aboutTurnAndHalt: "Helt om og holdt"
        }
    }
}

struct Fot: View {
    @State private var duration: Int = 2
    @State private var isEditing = false
    @State private var commandSpeed: CommandSpeed = .normal
    
    @State private var audioCommand = AudioCommand()
    
    
    // Alle kommandoer er valgt som standard
    @State private var selectedCommands: Set<FotCommand> = Set(FotCommand.allCases)

    private func binding(for command: FotCommand) -> Binding<Bool> {
        Binding(
            get: { selectedCommands.contains(command) },
            set: { isOn in
                if isOn {
                    selectedCommands.insert(command)
                } else {
                    selectedCommands.remove(command)
                }
            }
        )
    }

    var body: some View {
        NavigationStack {
            
            Form {
                Section {
                    
                } header: {
                    Text("Sett sammen en lineføringsøkt og få kommandoene opplest på øret.")
                        .font(.subheadline)
//                        .foregroundStyle(.secondary)
//                        .listRowBackground(Color.clear)
                        .textCase(nil)
                        .listRowInsets(EdgeInsets())
                }
                
                Section("Øktens lengde") {
                    VStack {
                        LabeledContent("Varighet", value: "\(duration) min")
                        Slider(
                            value: Binding(
                                get: { Double(duration) },
                                set: { duration = Int($0) }
                            ),
                            in: 1...5,
                            step: 1,
                            onEditingChanged: { editing in
                                isEditing = editing
                            }
                        )
                    }
                }// .listRowSeparator(.hidden)
                
                Section("Tempo på kommandoene") {
                    Picker("Tempo", selection: $commandSpeed) {
                        Text("Sakte").tag(CommandSpeed.slow)
                        Text("Normal").tag(CommandSpeed.normal)
                        Text("Intensiv").tag(CommandSpeed.intensive)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    ForEach(FotCommand.allCases) { command in
                        Toggle(command.title, isOn: binding(for: command))
                    }
                } header: {
                    HStack {
                        Text("Kommandoer")
                        Spacer()
                        Button(selectedCommands.count == FotCommand.allCases.count ? "Fjern alle" : "Velg alle") {
                            if selectedCommands.count == FotCommand.allCases.count {
                                selectedCommands.removeAll()
                            } else {
                                selectedCommands = Set(FotCommand.allCases)
                            }
                        }
                    }
                } footer: {
                    VStack {
                        Button {
                            Task {
                                audioCommand.say("Fremmad marsj")
                            }
                        } label: {
                            Text("Start økt")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.glassProminent)
                        .controlSize(.large)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical)
                    }
                    
                }
            }
            .navigationTitle("Fot")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
        Fot()
}
