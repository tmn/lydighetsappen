//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

extension FotCommand {
    /// Required commands - a session cannot exist without these
    var isRequired: Bool {
        switch self {
        case .forwardMarch, .normalMarch, .halt: true
        default: false
        }
    }

    /// Kommandoer som gjør at ekvipasjen står stille etter at de er utført, og hunden skal sette seg.
    var endsInHalt: Bool {
        switch self {
        case .halt, .leftTurnAndHalt, .rightTurnAndHalt, .aboutTurnAndHalt: true
        default: false
        }
    }

    /// Kommandoer som krever at ekvipasjen står i utgangsstilling.
    var isStationaryMovement: Bool {
        switch self {
        case .twoStepForward, .twoStepBackward, .twoStepLeft, .twoStepRight, .walkBackward, .walkBackwardLong: true
        default: false
        }
    }

    var isTurn: Bool {
        switch self {
        case .leftTurn, .rightTurn, .aboutTurn: true
        default: false
        }
    }

    var isTurnAndHalt: Bool {
        switch self {
        case .leftTurnAndHalt, .rightTurnAndHalt, .aboutTurnAndHalt: true
        default: false
        }
    }

    /// Forhåndsvalgte kommandoer for en klasse.
    static func preset(for lpClass: LPClass) -> Set<FotCommand> {
        // Klasse 1: vendinger og holdt i vanlig marsj. Sakte marsj og springmarsj uten vendinger og holdt.
        var commands: Set<FotCommand> = [
            .forwardMarch, .normalMarch, .halt,
            .leftTurn, .rightTurn, .aboutTurn,
            .slowMarch, .runMarch
        ]
        switch lpClass {
        case .klasse1:
            break
        case .klasse2:
            // Holdt kan komme som følge av en vending, og forflytninger på 2 skritt framover og bakover.
            commands.formUnion([.leftTurnAndHalt, .rightTurnAndHalt, .aboutTurnAndHalt])
            commands.formUnion([.twoStepForward, .twoStepBackward])
        case .klasse3:
            commands.formUnion([.leftTurnAndHalt, .rightTurnAndHalt, .aboutTurnAndHalt])
            commands.formUnion([.twoStepForward, .twoStepBackward, .twoStepLeft, .twoStepRight])
            commands.insert(.walkBackward)
        case .fci3:
            commands.formUnion([.leftTurnAndHalt, .rightTurnAndHalt, .aboutTurnAndHalt])
            commands.formUnion([.twoStepForward, .twoStepBackward, .twoStepLeft, .twoStepRight])
            commands.insert(.walkBackwardLong)
        }
        return commands
    }
}

/// En kommando i en økt, med pausen som følger etter at den er lest opp.
struct FotStep: Identifiable {
    let id = UUID()
    let command: FotCommand
    /// Sekunder fra opplesingen er ferdig til neste kommando.
    let pause: TimeInterval
}

struct FotPlanner {
    enum Gait {
        case normal, slow, run
    }

    enum State: Equatable {
        /// Ekvipasjen står i utgangsstilling.
        case halted
        case marching(Gait)
    }

    let lpClass: LPClass
    let commands: Set<FotCommand>

    /// Tid det tar å lese opp en kommando. Brukes bare til å anslå økta lengde.
    private let spokenDuration: TimeInterval = 1.2

    init(lpClass: LPClass, commands: Set<FotCommand>) {
        self.lpClass = lpClass
        self.commands = commands.union(FotCommand.allCases.filter(\.isRequired))
    }

    /// Vendinger på stedet (ved holdt) forekommer i klasse 3 og FCI 3.
    private var allowsTurnsOnSpot: Bool {
        lpClass == .klasse3 || lpClass == .fci3
    }

    /// Kommandoer som kan komme etter `previous` i gitt tilstand.
    func legalCommands(after previous: FotCommand?, state: State) -> [FotCommand] {
        let candidates: [FotCommand]
        switch state {
        case .halted:
            var options: [FotCommand] = [.forwardMarch]
            options += FotCommand.allCases.filter(\.isStationaryMovement)
            if allowsTurnsOnSpot {
                options += FotCommand.allCases.filter(\.isTurn)
            }
            candidates = options
        case .marching(.normal):
            var options: [FotCommand] = [.halt, .slowMarch, .runMarch]
            options += FotCommand.allCases.filter { $0.isTurn || $0.isTurnAndHalt }
            candidates = options
        case .marching:
            if lpClass == .klasse1 {
                // Klasse 1: sakte marsj og springmarsj følges alltid av vanlig marsj, uten vendinger og holdt.
                candidates = [.normalMarch]
            } else {
                var options: [FotCommand] = [.normalMarch, .halt]
                options += FotCommand.allCases.filter { $0.isTurn || $0.isTurnAndHalt }
                candidates = options
            }
        }
        
        // Samme kommando skal ikke komme to ganger etter hverandre.
        return candidates.filter { commands.contains($0) && $0 != previous }
    }

    func state(after command: FotCommand, from state: State) -> State {
        switch command {
        case .forwardMarch, .normalMarch: .marching(.normal)
        case .slowMarch: .marching(.slow)
        case .runMarch: .marching(.run)
        case .halt, .leftTurnAndHalt, .rightTurnAndHalt, .aboutTurnAndHalt: .halted
        case .leftTurn, .rightTurn, .aboutTurn: state
        case .twoStepForward, .twoStepBackward, .twoStepLeft, .twoStepRight, .walkBackward, .walkBackwardLong: .halted
        }
    }

    /// Pausen etter at `command` er lest opp, før neste kommando kommer.
    func pause(
        after command: FotCommand,
        base: TimeInterval,
        using generator: inout some RandomNumberGenerator
    ) -> TimeInterval {
        if command.endsInHalt {
            return TimeInterval.random(in: 1.0...2.0, using: &generator)
        }
        if command.isStationaryMovement {
            // Noen få skritt på stedet tar ikke lang tid, men baklengs gange tar lengre.
            let isBackwardWalk = command == .walkBackward || command == .walkBackwardLong
            let factor = isBackwardWalk ? 1.0...1.5 : 0.5...0.9
            return max(3, base * Double.random(in: factor, using: &generator))
        }
        return max(2.5, base * Double.random(in: 0.6...1.4, using: &generator))
    }

    /// Lager en plan som varer omtrent `duration` sekunder... `pauseBase` er tempoet, i sekunder mellom hver kommando.
    func plan(
        duration: TimeInterval,
        pauseBase: TimeInterval,
        using generator: inout some RandomNumberGenerator
    ) -> [FotStep] {
        var result: [FotStep] = []
        var state = State.halted
        var elapsed: TimeInterval = 0

        func append(_ command: FotCommand) {
            let pause = pause(after: command, base: pauseBase, using: &generator)
            result.append(FotStep(command: command, pause: pause))
            state = self.state(after: command, from: state)
            elapsed += spokenDuration + pause
        }

        while elapsed < duration {
            let options = legalCommands(after: result.last?.command, state: state)
            guard let next = pick(from: options, state: state, using: &generator) else { break }
            append(next)
        }

        // Avslutt alltid med holdt, eller en vending med holdt.
        if let last = result.last?.command, !last.endsInHalt {
            if state == .halted {
                append(.forwardMarch)
            } else if case .marching(let gait) = state, gait != .normal, lpClass == .klasse1 {
                append(.normalMarch)
            }
            append(.halt)
        }
        return result
    }

    private func pick(
        from options: [FotCommand],
        state: State,
        using generator: inout some RandomNumberGenerator
    ) -> FotCommand? {
        // Når ekvipasjen står stille bør halvparten av kommandoene være å gå videre,
        // ellers blir økta full av forflytninger på stedet.
        if state == .halted, options.contains(.forwardMarch), options.count > 1, Bool.random(using: &generator) {
            return .forwardMarch
        }
        return options.randomElement(using: &generator)
    }
}
