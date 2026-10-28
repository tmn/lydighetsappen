//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

enum CommandSpeed: String {
    case slow, normal, intensive
    var id: Self { self }

    /// Average pause in between commands
    var secondsBetweenCommands: TimeInterval {
        switch self {
        case .slow: 6
        case .normal: 4
        case .intensive: 2.5
        }
    }
}

/// Kommandoer som kan brukes i lineføring / fri ved fot i konkurranselydighet (LP).
///
/// Hvilke som er forhåndsvalgt i hver klasse står i `FotCommand.preset(for:)`,
/// og reglene for rekkefølge står i `FotPlanner`.
///
/// Klasse 1:
/// Øvelsen skal inneholde vanlig marsj med vendinger og holdt, sakte marsj og springmarsj uten holdt og vendinger. Hunden skal raskt, uten kommando, innta utgangsstilling når føreren gjør holdt.
/// Maks 1 min
///
/// Klasse 2:
/// Øvelsen skal inneholde vanlig og sakte marsj med vendinger og holdt, samt springmarsj. Det bør også være vendinger under springmarsj. Øvelsen kan også inneholde forflytninger, med 2 skritt, fremover og bakover.
/// Maks 1 min
///
/// Klasse 3:
/// Øvelsen skal inneholde vanlig, sakte og springmarsj med vendinger og holdt. Det skal også være vendinger ved holdt på stedet, og 2 skritt forflytninger i ulike retninger, og ca. 3 meter baklengsgange. (5-8 skritt /2-3 meter).
/// Maks 2 min
///
/// FCI 3:
/// Som klasse 3, men baklengs gange er ca. 5-10 meter (15-30 skritt), og skal inkludere en vending.
enum FotCommand: String, CaseIterable, Identifiable {
    case forwardMarch
    case halt
    case rightTurn
    case leftTurn
    case aboutTurn
    case slowMarch
    case normalMarch
    case runMarch
    case leftTurnAndHalt
    case rightTurnAndHalt
    case aboutTurnAndHalt
    case twoStepForward
    case twoStepBackward
    case twoStepLeft
    case twoStepRight
    case walkBackward
    case walkBackwardLong

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
        case .leftTurnAndHalt: "Venstre om og holdt"
        case .rightTurnAndHalt: "Høyre om og holdt"
        case .aboutTurnAndHalt: "Helt om og holdt"
        case .twoStepForward: "To skritt fremover"
        case .twoStepBackward: "To skritt bakover"
        case .twoStepLeft: "To skritt til venstre"
        case .twoStepRight: "To skritt til høyre"
        case .walkBackward: "3 meter bakover"
        case .walkBackwardLong: "5–10 meter bakover, med vending"
        }
    }

    var spokenText: String {
        switch self {
        case .forwardMarch: "Fremmad, marsj"
        case .halt: "Holdt"
        case .rightTurn: "Høyre, om"
        case .leftTurn: "Venstre, om"
        case .aboutTurn: "Helt, om"
        case .slowMarch: "Sakte marsj"
        case .normalMarch: "Vanlig marsj"
        case .runMarch: "Springmarsj"
        case .leftTurnAndHalt: "Venstre om og holdt"
        case .rightTurnAndHalt: "Høyre om og holdt"
        case .aboutTurnAndHalt: "Helt om og holdt"
        case .twoStepForward: "To skritt fremover"
        case .twoStepBackward: "To skritt bakover"
        case .twoStepLeft: "To skritt til venstre"
        case .twoStepRight: "To skritt til høyre"
        case .walkBackward: "Tre meter bakover"
        case .walkBackwardLong: "Fem til ti meter, bakover, med vending"
        }
    }
}

struct FotView: View {
    @State private var lpClass: LPClass = .klasse1
    @State private var duration: Int = LPClass.klasse1.recommendedFootMinutes
    @State private var isEditing = false
    @State private var commandSpeed: CommandSpeed = .normal
    
    @State private var audioCommand = AudioCommand()
    @State private var session: FotSession?
    
    @State private var selectedCommands: Set<FotCommand> = FotCommand.preset(for: .klasse1)

    private var requiredCommands: Set<FotCommand> {
        Set(FotCommand.allCases.filter(\.isRequired))
    }

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
    
    private func startSession() {
        let planner = FotPlanner(lpClass: lpClass, commands: selectedCommands)
        var generator = SystemRandomNumberGenerator()
        let steps = planner.plan(
            duration: TimeInterval(duration * 60),
            pauseBase: commandSpeed.secondsBetweenCommands,
            using: &generator
        )
        session = FotSession(steps: steps, audio: audioCommand)
    }

    var body: some View {
        NavigationStack {
            
            Form {
                Section {
                    
                } header: {
                    Text("Sett sammen en \(lpClass.footExerciseName.lowercased())-økt og få kommandoene opplest på øret.")
                        .font(.subheadline)
                        .textCase(nil)
                        .listRowInsets(EdgeInsets())
                }
                
                Section {
                    Picker("Klasse", selection: $lpClass) {
                        ForEach(LPClass.allCases) { lpClass in
                            Text(lpClass.shortTitle).tag(lpClass)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Klasse")
                } footer: {
                    Text(lpClass.footExerciseName == "Lineføring"
                         ? "Lineføring: i klasse 1 går hunden i fritt hengende line."
                         : "Fri ved fot: hunden går uten line.")
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
                        Text("Rolig").tag(CommandSpeed.slow)
                        Text("Normal").tag(CommandSpeed.normal)
                        Text("Intensiv").tag(CommandSpeed.intensive)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    ForEach(FotCommand.allCases) { command in
                        Toggle(command.title, isOn: binding(for: command))
                            .disabled(command.isRequired)
                    }
                } header: {
                    HStack {
                        Text("Kommandoer")
                        Spacer()
                        Menu("Velg") {
                            Button("Klassens valg") {
                                selectedCommands = FotCommand.preset(for: lpClass)
                            }
                            Button("Velg alle") {
                                selectedCommands = Set(FotCommand.allCases)
                            }
                            Button("Fjern alle") {
                                selectedCommands = requiredCommands
                            }
                        }
                    }
                } footer: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fremad marsj, vanlig marsj og holdt er alltid med. Økta starter i utgangsstilling og avsluttes alltid med holdt.")
                            .font(.footnote)
                    }
                }
            }

            .safeAreaInset(edge: .bottom) {
                Button {
                    startSession()
                } label: {
                    Text("Start økt")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .controlSize(.large)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .navigationTitle("Fot")
            .navigationBarTitleDisplayMode(.large)
            .onChange(of: lpClass) { _, newClass in
                selectedCommands = FotCommand.preset(for: newClass)
                duration = newClass.recommendedFootMinutes
            }
            .fullScreenCover(isPresented: Binding(
                get: { session != nil },
                set: { if !$0 { session = nil } }
            )) {
                if let session {
                    FotSessionView(session: session)
                }
            }
        }
    }
}

#Preview {
        FotView()
}
