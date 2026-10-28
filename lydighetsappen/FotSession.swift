//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

@MainActor
@Observable
final class FotSession {
    let steps: [FotStep]
    private let audio: AudioCommand
    private var task: Task<Void, Never>?

    private(set) var currentIndex: Int?
    private(set) var isFinished = false

    init(steps: [FotStep], audio: AudioCommand) {
        self.steps = steps
        self.audio = audio
    }

    var commands: [FotCommand] {
        steps.map(\.command)
    }

    var currentCommand: FotCommand? {
        currentIndex.map { commands[$0] }
    }

    var nextCommand: FotCommand? {
        let next = (currentIndex ?? -1) + 1
        return commands.indices.contains(next) ? commands[next] : nil
    }

    func start() {
        guard task == nil else { return }
        task = Task { [self] in
            await audio.speak("Gjør klar")
            try? await Task.sleep(for: .seconds(3))

            for (index, step) in steps.enumerated() {
                if Task.isCancelled { return }
                currentIndex = index

                await audio.speak(step.command.spokenText)
                // Pausen regnes fra opplesingen er ferdig, og er planlagt per kommando.
                try? await Task.sleep(for: .seconds(step.pause))
            }
            if Task.isCancelled { return }
            isFinished = true
            await audio.speak("Ferdig")
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        audio.stop()
    }
}

struct FotSessionView: View {
    let session: FotSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            if session.isFinished {
                Label("Ferdig", systemImage: "checkmark.circle.fill")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.green)
            } else if let command = session.currentCommand {
                Text(command.title)
                    .font(.system(size: 44, weight: .bold))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .contentTransition(.opacity)
            } else {
                Text("Gjør klar")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.secondary)
            }

            if let next = session.nextCommand, !session.isFinished {
                Text("Neste: \(next.title)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ProgressView(
                value: Double(session.isFinished ? session.commands.count : (session.currentIndex ?? 0)),
                total: Double(session.commands.count)
            )

            Button {
                session.stop()
                dismiss()
            } label: {
                Text(session.isFinished ? "Lukk" : "Stopp")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
        }
        .padding()
        .animation(.default, value: session.currentIndex)
        .interactiveDismissDisabled()
        .task {
            session.start()
        }
        .onAppear {
            // Keep display on while Fot-ing
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            session.stop()
        }
    }
}
