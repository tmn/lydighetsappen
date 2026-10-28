//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct LPStep: Hashable {
    let text: String
    let isOrdered: Bool

    static func order(_ text: String) -> LPStep { LPStep(text: text, isOrdered: true) }
    static func info(_ text: String) -> LPStep { LPStep(text: text, isOrdered: false) }
}

struct LPExercise: Identifiable, Hashable {
    let number: String
    let title: String
    let coefficient: Int
    let summary: String
    let commands: [String]
    let steps: [LPStep]
    let judging: [String]

    var id: String { number }
}

enum LPClass: String, CaseIterable, Identifiable {
    case klasse1, klasse2, klasse3, fci3

    var id: Self { self }

    var title: String {
        switch self {
        case .klasse1: "Klasse 1"
        case .klasse2: "Klasse 2"
        case .klasse3: "Klasse 3"
        case .fci3: "FCI 3"
        }
    }

    var shortTitle: String {
        switch self {
        case .klasse1: "Kl. 1"
        case .klasse2: "Kl. 2"
        case .klasse3: "Kl. 3"
        case .fci3: "FCI 3"
        }
    }

    var systemImage: String {
        switch self {
        case .klasse1: "1.circle"
        case .klasse2: "2.circle"
        case .klasse3: "3.circle"
        case .fci3: "pawprint.circle"
        }
    }

    /// I klasse 1 heter øvelsen «Lineføring», else «Fri ved fot».
    var footExerciseName: String {
        self == .klasse1 ? "Lineføring" : "Fri ved fot"
    }

    var tagline: String {
        switch self {
        case .klasse1: "Grunnleggende samarbeid: tilgjengelighet, lineføring, dekk og innkalling."
        case .klasse2: "Stå eller dekk under marsj, apportering over hinder og fremadsending rundt kjegler."
        case .klasse3: "Skjult fører, dirigering, apportering med dirigering og neseprøve."
        case .fci3: "Den internasjonale klassen med de mest krevende øvelsene."
        }
    }

    var introduction: String {
        switch self {
        case .klasse1:
            "Første klasse i LP. Åpen for hunder som ikke tidligere har deltatt i klasse 2. Her legges grunnlaget: hunden skal være tilgjengelig, følge villig og kunne bli, komme og stoppe på kommando."
        case .klasse2:
            "Åpen for hunder som har oppnådd 1. premie i klasse 1. Nå kommer stå og dekk under marsj, apportering over hinder og fremadsending rundt kjegler."
        case .klasse3:
            "Åpen for hunder som har oppnådd 1. premie i klasse 2. Føreren skjules for hunden, og hunden skal dirigeres, apportere med dirigering og gjøre neseprøve."
        case .fci3:
            "Den internasjonale klassen. Hunden må ha 1. premie i klasse 3 og være minst 15 måneder. Øvelsene er mer krevende og beskrives nøyaktig for internasjonale konkurranser."
        }
    }

    var exercises: [LPExercise] {
        switch self {
        case .klasse1: LPContent.klasse1
        case .klasse2: LPContent.klasse2
        case .klasse3: LPContent.klasse3
        case .fci3: LPContent.fci3
        }
    }

    var maxPoints: Int {
        exercises.reduce(0) { $0 + $1.coefficient } * 10
    }

    /// Laveste poengsum for 1., 2. og 3. premie: 80 %, 70 % og 60 % av maks poengsum.
    var prizeThresholds: [(prize: Int, points: Int)] {
        [(1, 80), (2, 70), (3, 60)].map { (prize: $0.0, points: maxPoints * $0.1 / 100) }
    }

    /// Anbefalt maksimaltid for fot-øvelsen i minutter.
    var recommendedFootMinutes: Int {
        switch self {
        case .klasse1, .klasse2: 1
        case .klasse3: 2
        case .fci3: 3
        }
    }
}

// MARK: - Innhold

enum LPContent {
    static let klasse1: [LPExercise] = [
        LPExercise(
            number: "1.1", title: "Tilgjengelighet", coefficient: 2,
            summary: "Obligatorisk øvelse som avdekker uønsket adferd. Dommeren sjekker at hunden kan håndteres normalt.",
            commands: ["Bli"],
            steps: [
                .info("Hunden sitter i utgangsstilling."),
                .info("Dommeren stiller seg foran ekvipasjen og spør om dere er klare."),
                .info("Du svarer at dere er klare og kommanderer «bli»."),
                .info("Dommeren kontrollerer tilgjengeligheten ved å berøre hundens snuteparti.")
            ],
            judging: [
                "Aggressivitet gir underkjent øvelse og utvisning.",
                "Hunden skal sitte i ro og ikke sette seg til motverge.",
                "Reiser hunden seg, er høyeste karakter 8."
            ]
        ),
        LPExercise(
            number: "1.2", title: "Fellesdekk 1 minutt", coefficient: 5,
            summary: "Flere hunder ligger i dekk samtidig mens førerne står synlige i 1 minutt.",
            commands: ["Dekk", "Bli", "Utgangsstilling"],
            steps: [
                .info("Førerne stiller på linje med ca. 4 meter mellom ekvipasjene. Hundene sitter i utgangsstilling."),
                .order("Du kommanderer «dekk»."),
                .order("Du kommanderer «bli» og forlater hunden. Gå ca. 5 meter."),
                .order("Du gjør helt om og holdt, vendt mot hunden."),
                .info("Du står vendt mot hunden i 1 minutt. Tiden starter når alle førerne står vendt mot hundene."),
                .order("Du går tilbake og gjør helt om og holdt ca. 2 skritt bak hunden."),
                .order("Du går inntil hunden."),
                .order("Du kommanderer «utgangsstilling»."),
                .info("Etter «øvelsen slutt» forholder du deg i ro til du får annen beskjed.")
            ],
            judging: [
                "Hunden skal legge seg raskt og bli liggende.",
                "Reiser hunden seg før tiden har startet, underkjennes øvelsen.",
                "Reiser eller setter hunden seg etter at tiden har startet, er høyeste karakter 5.",
                "Flytter hunden seg mer enn 3 kroppslengder før tiden er ute, underkjennes øvelsen."
            ]
        ),
        LPExercise(
            number: "1.3", title: "Lineføring", coefficient: 4,
            summary: "Eneste øvelse med line. Hunden følger villig på din venstre side i fritt hengende line.",
            commands: ["Fot"],
            steps: [
                .info("Start i utgangsstilling. Linen holdes i valgfri hånd og henger fritt."),
                .order("Du kommanderer «fot» og går vanlig marsj. «Fot» er tillatt fra holdt og ved forandring av gangart."),
                .order("Du gjør vendinger og holdt i vanlig marsj."),
                .order("Du går sakte marsj og springmarsj. Disse gjøres uten holdt og vendinger."),
                .info("Når du gjør holdt, skal hunden raskt innta utgangsstilling uten kommando."),
                .info("Anbefalt tid: ca. 1 minutt.")
            ],
            judging: [
                "Hundens skulder skal være ved ditt venstre kne, parallelt med deg.",
                "Stram line hele tiden, eller en hund som må dras fram, underkjennes.",
                "Treghet, manglende kontakt, ploging, skjeve holter og ekstra kommandoer er feil."
            ]
        ),
        LPExercise(
            number: "1.4", title: "Dekk fra holdt", coefficient: 4,
            summary: "Hunden legger seg på kommando etter holdt, og blir liggende mens du går fra og tilbake.",
            commands: ["Fot", "Dekk", "Utgangsstilling"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du kommanderer «fot» og går ca. 10 meter."),
                .order("Du gjør holdt. Hunden skal innta utgangsstilling uten kommando."),
                .order("Du kommanderer «dekk»."),
                .order("Du går ca. 10 meter fra hunden og gjør helt om og holdt."),
                .order("Du går tilbake og passerer hunden på dens venstre side, ca. 0,5 meter unna og ca. 2 skritt bak hunden."),
                .order("Du gjør helt om og marsj, og holdt inntil hunden."),
                .order("Du kommanderer «utgangsstilling».")
            ],
            judging: [
                "Dekk er hovedmomentet: hvor villig hunden legger seg og blir liggende.",
                "Dekker ikke hunden på første kommando, er høyeste karakter 8.",
                "Reiser hunden seg før du har gjort helt om og holdt, er høyeste karakter 5.",
                "Bruker du «bli» når du går fra, er høyeste karakter 8."
            ]
        ),
        LPExercise(
            number: "1.5", title: "Innkalling fra sitt", coefficient: 3,
            summary: "Hunden blir sittende mens du går fra, og kommer raskt til deg når du kaller.",
            commands: ["Bli", "Kom"],
            steps: [
                .info("Start på anvist plass med hunden i utgangsstilling."),
                .order("Du kommanderer «bli»."),
                .order("Du går ca. 15 meter fra hunden."),
                .order("Du gjør helt om og holdt."),
                .order("Du kaller inn hunden til utgangsstilling («kom»).")
            ],
            judging: [
                "Hunden skal komme villig, i god fart og velge korteste vei.",
                "Én ekstra kommando gir høyst 8.",
                "Forlater hunden plassen med mer enn 3 kroppslengder før du har gjort helt om, underkjennes øvelsen."
            ]
        ),
        LPExercise(
            number: "1.6", title: "Fremadsending med stå", coefficient: 4,
            summary: "Du sender hunden inn i en rute og stopper den der med «stå».",
            commands: ["Fremad", "Stå"],
            steps: [
                .info("Ruta er ca. 3×3 meter, markert med kjegle i hvert hjørne, og ligger ca. 10 meter fra start."),
                .info("Hunden står i utgangsstilling med fronten mot en av sidene på ruta. Du kan vise hunden ruta kort."),
                .order("Du sender hunden inn i ruta («fremad»)."),
                .info("Du kommanderer «stå» når hunden er i ruta."),
                .info("Når hunden har stått stille i ca. 2 sekunder, er øvelsen ferdig bedømt."),
                .order("Du henter hunden i ruta.")
            ],
            judging: [
                "To bein må være innenfor ruta for å bli godkjent.",
                "Høyeste karakter krever maks to kommanderinger (fremad og stå).",
                "Tar hunden feil moment (sitt/dekk) trekkes 2 poeng.",
                "Tyvstart gir høyst 8."
            ]
        ),
        LPExercise(
            number: "1.7", title: "Hopp over hinder", coefficient: 4,
            summary: "Hunden blir igjen, og hopper over hinderet til deg når du kaller.",
            commands: ["Fot", "Bli", "Hopp"],
            steps: [
                .info("Hinderet er tett, i hundens skulderhøyde, maks 50 cm. Start i utgangsstilling vendt mot hinderet, 3–5 meter unna (ditt valg)."),
                .order("Du kommanderer «bli» og går fra hunden, forbi hinderet på siden."),
                .order("Du gjør helt om og holdt 3–5 meter bak hinderet (ditt valg)."),
                .order("Du kaller inn hunden over hinderet til utgangsstilling.")
            ],
            judging: [
                "Vegrer hunden én gang, er høyeste karakter 7. Andre vegring underkjenner.",
                "Går hunden rundt hinderet, underkjennes øvelsen.",
                "Berører hunden hinderet, er høyeste karakter 8. Ansats gir høyst 5.",
                "Rives hinderet, underkjennes øvelsen."
            ]
        ),
        LPExercise(
            number: "1.8", title: "Kontroll over hunden på avstand", coefficient: 4,
            summary: "Du skifter hundens stilling tre ganger fra 2 meters avstand.",
            commands: ["Utgangsstilling", "Sitt", "Dekk"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du forlater hunden og gjør helt om og holdt på anvist plass, ca. 2 meter fra hunden."),
                .order("Konkurranselederen viser når hver stillingsforandring skal skje, og du kommanderer «sitt» eller «dekk». Hunden skifter stilling 3 ganger, og hver stilling holdes ca. 3 sekunder."),
                .info("Siste stilling skal være dekk."),
                .order("Du går inntil hunden."),
                .order("Du kommanderer «utgangsstilling».")
            ],
            judging: [
                "Hvor raskt hunden skifter stilling, og hvor lite den flytter seg.",
                "For å bli godkjent må hunden skifte stilling minst 2 ganger.",
                "Flytter hunden seg mer enn 2 kroppslengder, underkjennes øvelsen.",
                "Hver ekstra kommando gir ½–1 poeng trekk."
            ]
        ),
        LPExercise(
            number: "1.9", title: "Helhetsinntrykk", coefficient: 2,
            summary: "Dommerens samlede inntrykk av samarbeidet gjennom hele konkurransen.",
            commands: [],
            steps: [
                .info("Vurderes underveis og mellom øvelsene."),
                .info("Maks poengsum i klassen: 320.")
            ],
            judging: [
                "Samarbeid mellom hund og fører, arbeidsvilje og arbeidsglede.",
                "Rasens temperament tas hensyn til.",
                "Karakteren er selvstendig og er ikke nødvendigvis gjennomsnittet av de andre."
            ]
        )
    ]

    static let klasse2: [LPExercise] = [
        LPExercise(
            number: "2.1", title: "Felles sitt 1 minutt, synlig fører", coefficient: 3,
            summary: "Hundene sitter i 1 minutt mens førerne står synlige 10 meter unna.",
            commands: ["Sitt"],
            steps: [
                .info("Førerne stiller på linje med ca. 4 meter mellom ekvipasjene. Hundene sitter i utgangsstilling."),
                .order("Du forlater hunden og går ca. 10 meter til anvist plass."),
                .order("Du gjør helt om og holdt, vendt mot hunden."),
                .info("Du står vendt mot hunden i 1 minutt. Tiden starter når alle førerne har nådd 10 meter og gjort helt om."),
                .order("Du går tilbake og inntil hunden."),
                .info("Etter «øvelsen er slutt» forholder du deg i ro til du får annen beskjed.")
            ],
            judging: [
                "Hunden som ikke vil sitte, reiser seg, legger seg eller flytter seg mer enn 2 kroppslengder, underkjennes.",
                "Uro, bjeffing og piping senker karakteren.",
                "Reiser eller legger hunden seg etter at minuttet er over, er høyeste karakter 7."
            ]
        ),
        LPExercise(
            number: "2.2", title: "Fri ved fot", coefficient: 4,
            summary: "Fri ved fot uten line. Vanlig og sakte marsj, springmarsj, vendinger og holdt, og forflytninger på 2 skritt.",
            commands: ["Fot"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du kommanderer «fot» og går marsj. «Fot» er tillatt fra holdt og ved forandring av gangart."),
                .order("Du går vanlig og sakte marsj med vendinger og holdt, og springmarsj. Det bør også være vendinger under springmarsj."),
                .order("Øvelsen kan også inneholde forflytninger på 2 skritt, fremover og bakover."),
                .info("Når du gjør holdt, skal hunden raskt innta utgangsstilling uten kommando."),
                .info("Anbefalt tid: ca. 1 minutt.")
            ],
            judging: [
                "Hunden som forlater deg eller holder mer enn 0,5 meter avstand store deler av øvelsen, underkjennes.",
                "Går dere sakte, bør 2–4 karakterer trekkes.",
                "Gjennomgående skjev fotposisjon gir høyst 8.",
                "Avstanden skal være tydelig: hunden skal ikke klenge på deg."
            ]
        ),
        LPExercise(
            number: "2.3", title: "Stå eller dekk under marsj", coefficient: 3,
            summary: "Hunden stopper i stå eller dekk mens du fortsetter å gå, og du henter den igjen.",
            commands: ["Fot", "Stå eller dekk"],
            steps: [
                .info("Dommeren avgjør om momentet er stå eller dekk, likt for alle."),
                .order("Du kommanderer «fot» og går vanlig marsj ca. 10 meter."),
                .order("Du kommanderer hunden til stå eller dekk, og fortsetter marsjen alene ca. 10 meter."),
                .order("Du gjør helt om og holdt. Etter ca. 3 sekunder får du beskjed om å gå tilbake."),
                .order("Du går tilbake og passerer hunden på dens venstre side, ca. 0,5 meter unna."),
                .order("Du gjør helt om og marsj ca. 2 skritt bak hunden, går inntil den og tar den med fri ved fot."),
                .order("Etter ca. 3 meters marsj gjør du holdt. Hunden skal automatisk innta utgangsstilling.")
            ],
            judging: [
                "Hunden skal stoppe raskt i riktig moment og innenfor 2 kroppslengder.",
                "Stopper ikke hunden på 2 kommandoer, underkjennes øvelsen.",
                "Du skal ikke endre gangfart eller stoppe før kommandoen, og ikke bruke overdrevne signaler.",
                "Feil side ved passering: 1 poeng trekk."
            ]
        ),
        LPExercise(
            number: "2.4", title: "Innkalling fra sitt med stå", coefficient: 4,
            summary: "Innkalling over 20 meter, hvor hunden stoppes med «stå» underveis.",
            commands: ["Bli", "Kom", "Stå"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du forlater den sittende hunden, går ca. 20 meter og gjør helt om og holdt på anvist plass."),
                .order("Du kaller inn hunden («kom»)."),
                .info("Før hunden har passert halve strekningen, kommanderer du «stå»."),
                .order("Du kaller inn hunden til utgangsstilling.")
            ],
            judging: [
                "Hunden skal komme villig, i god fart og ta korteste vei.",
                "Hunden må stoppe minst 5 meter fra deg for at stå-momentet godkjennes.",
                "Adlyder ikke hunden stå innenfor 5 kroppslengder, underkjennes øvelsen.",
                "Setter eller legger hunden seg under innkallingen etter stå, er høyeste karakter 7."
            ]
        ),
        LPExercise(
            number: "2.5", title: "Fremadsending med dekk", coefficient: 4,
            summary: "Du sender hunden 15 meter til ruta og legger den ned der.",
            commands: ["Fremad", "(Stå)", "Dekk", "Utgangsstilling"],
            steps: [
                .info("Før øvelsen sier du fra til dommeren om du vil bruke «stå» før «dekk» i ruta, eller direkte «dekk»."),
                .info("Ruta er 3×3 meter og ligger ca. 15 meter fra start. Du kan vise hunden ruta kort."),
                .order("Du sender hunden inn i ruta («fremad»). Den skal gå i rett linje og inn i ruta fra fremsiden."),
                .info("Du kommanderer «dekk» (eventuelt «stå» først) når hunden er i ruta."),
                .order("Du går inntil hunden."),
                .order("Du kommanderer «utgangsstilling».")
            ],
            judging: [
                "Maks 4 kommandoer for høyeste karakter (den fjerde er stå i ruta). Direkte dekk gir 3.",
                "Flytter du deg bort fra startpunktet under kommanderingen, underkjennes øvelsen.",
                "Hele hunden (unntatt halen) skal ligge innenfor ruta for høyeste karakter.",
                "Legger hunden seg utenfor ruta, underkjennes øvelsen."
            ]
        ),
        LPExercise(
            number: "2.6", title: "Kontroll over hunden på avstand", coefficient: 4,
            summary: "Hunden skifter mellom sitt og dekk fire ganger fra 5 meters avstand.",
            commands: ["Dekk", "Sitt", "Utgangsstilling"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du kommanderer «dekk»."),
                .order("Du forlater hunden og går til anvist plass ca. 5 meter unna."),
                .order("Konkurranselederen viser når hver stillingsforandring skal skje. Rekkefølgen er sitt–dekk, og hunden skifter stilling 4 ganger. Hver stilling holdes ca. 3 sekunder."),
                .info("Siste stilling skal være dekk."),
                .order("Du går inntil hunden."),
                .order("Du kommanderer «utgangsstilling».")
            ],
            judging: [
                "Hurtighet, tydelighet og hvor lite hunden beveger seg.",
                "Hunden må ikke flytte seg mer enn 1 hundelengde totalt, i alle retninger summert.",
                "Mister hunden én stillingsforandring, er høyeste karakter 7. To gir høyst 5.",
                "Håndsignaler skal være korte og samtidige med kommandoen."
            ]
        ),
        LPExercise(
            number: "2.7", title: "Apportering over hinder (lukket)", coefficient: 4,
            summary: "Hunden apporterer over et lukket hinder og avleverer til deg.",
            commands: ["Bli", "Apport", "(Hopp)", "Avlever"],
            steps: [
                .info("Hinderet er tett, i hundens skulderhøyde, maks 50 cm. Start i utgangsstilling vendt mot hinderet, ca. 7 meter unna."),
                .order("Du kommanderer «bli», går ca. 1 meter fra hunden og legger ned apporten."),
                .order("Du går videre på siden av hinderet og gjør helt om og holdt ca. 5 meter bak det."),
                .order("Du kommanderer «apport». Hunden apporterer over hinderet til utgangsstilling."),
                .order("Du kommanderer «avlever».")
            ],
            judging: [
                "Hunden som ikke hopper hinderet, underkjennes.",
                "Tar hunden opp apporten før du har gjort helt om og holdt, underkjennes øvelsen.",
                "Berører hunden hinderet, er høyeste karakter 8. Ansats gir høyst 5.",
                "Slipper hunden apporten 3 ganger, underkjennes øvelsen."
            ]
        ),
        LPExercise(
            number: "2.8", title: "Fremadsending rundt en gruppe kjegler og returnere", coefficient: 4,
            summary: "Du sender hunden rundt en kjeglegruppe 10 meter unna, og den kommer tilbake til utgangsstilling.",
            commands: ["Rundt"],
            steps: [
                .info("3–6 kjegler (40–50 cm høye) står samlet i et område på ca. 70–80 cm, ca. 10 meter fra start. De plasseres før du står ved startpunktet."),
                .info("Hunden står i utgangsstilling ved startpunktet. Du kan vise hunden kjeglene kort."),
                .order("Du sender hunden rundt kjeglene («rundt»)."),
                .info("Hunden løper rundt kjeglene, tilbake til deg og tar utgangsstilling.")
            ],
            judging: [
                "Hundens vilje, tempo og at den tar korteste vei.",
                "En tett runding er ikke ideelt. Avstand opp til 100 cm kan være passende.",
                "Tilbakekalling gir høyst 8. Runder hunden to ganger, er høyeste karakter 8.",
                "Går hunden mellom kjeglene, trekkes 3 poeng."
            ]
        ),
        LPExercise(
            number: "2.9", title: "Helhetsinntrykk", coefficient: 2,
            summary: "Dommerens samlede inntrykk av samarbeidet gjennom hele konkurransen.",
            commands: [],
            steps: [
                .info("Vurderes underveis og mellom øvelsene."),
                .info("Maks poengsum i klassen: 320.")
            ],
            judging: [
                "Samarbeid mellom hund og fører, arbeidsvilje og arbeidsglede.",
                "Rasens temperament tas hensyn til."
            ]
        )
    ]

    static let klasse3: [LPExercise] = [
        LPExercise(
            number: "3.1", title: "Fellesdekk 2 minutter med skjult fører", coefficient: 3,
            summary: "Hundene ligger i dekk i 2 minutter mens førerne er ute av syne.",
            commands: ["Dekk", "Bli", "Utgangsstilling"],
            steps: [
                .info("Førerne stiller på linje med ca. 4 meter mellom ekvipasjene. Hundene sitter i utgangsstilling."),
                .order("Du kommanderer hunden i dekk. Hundene legges ned én og én, fra venstre mot høyre."),
                .order("Du kommanderer «bli» og forlater hunden. Førerne går samlet i skjul."),
                .info("Dere er skjult i 2 minutter. Tiden starter når alle er i skjul."),
                .order("Du går tilbake og stiller deg på linje i ringen."),
                .order("Du passerer hunden på ca. 0,5 meters avstand og gjør helt om og holdt ca. 2 skritt bak hunden."),
                .order("Du stiller deg inntil hunden."),
                .order("Du kommanderer «utgangsstilling». Dette gjøres én og én, fra høyre mot venstre.")
            ],
            judging: [
                "Ikke kommander for høyt: det kan påvirke de andre hundene.",
                "Dekker hunden på andres kommando, er høyeste karakter 8.",
                "Flytter hunden seg mer enn 2 kroppslengder før dere er tilbake på linje, underkjennes øvelsen.",
                "Reiser hunden seg etter at dere står på linje, er høyeste karakter 5."
            ]
        ),
        LPExercise(
            number: "3.2", title: "Fri ved fot", coefficient: 4,
            summary: "Fri ved fot med alle gangarter, vendinger på stedet, forflytninger i ulike retninger og baklengsgange.",
            commands: ["Fot"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du kommanderer «fot» og går marsj. «Fot» er tillatt fra holdt og ved forandring av gangart."),
                .order("Du går vanlig, sakte og springmarsj med vendinger og holdt."),
                .order("Du gjør vendinger ved holdt på stedet."),
                .order("Du gjør forflytninger på 2 skritt i ulike retninger."),
                .order("Du går ca. 3 meter baklengs (5–8 skritt). Baklengs gange starter og slutter i utgangsstilling."),
                .info("Når du gjør holdt, skal hunden raskt innta utgangsstilling uten kommando."),
                .info("Anbefalt tid: ca. 2 minutter.")
            ],
            judging: [
                "Hunden som forlater deg eller holder mer enn 1 meter avstand store deler av øvelsen, underkjennes.",
                "Treghet gir ikke mer enn 7–8.",
                "Er hunden langt bak eller foran, trekkes 2–5 poeng.",
                "Gjennomgående skjev fotposisjon (ploging) trekkes 1–2 poeng."
            ]
        ),
        LPExercise(
            number: "3.3", title: "Sitt og dekk under marsj", coefficient: 3,
            summary: "Hunden stopper i sitt og dekk mens du går videre, og du henter den med fri ved fot.",
            commands: ["Fot", "Sitt", "Dekk"],
            steps: [
                .info("Dommeren avgjør rekkefølgen på sitt og dekk, lik for alle."),
                .info("Start i utgangsstilling ca. 0,5 meter til høyre for startmarkøren."),
                .order("Du starter vanlig marsj."),
                .order("Ca. midt på hver side kommanderer du hunden til sitt eller dekk."),
                .info("Du fortsetter marsjen alene rundt neste markør (180 grader til venstre) og passerer hunden på ca. 0,5 meters avstand."),
                .order("Du gjør helt om og marsj ca. 2 meter bak hunden."),
                .info("Når du kommer opp til hunden, kommanderer du fri ved fot («fot») uten å stoppe."),
                .order("Du gjør holdt ved siste markør.")
            ],
            judging: [
                "Hunden skal raskt utføre sitt og dekk. Minst ett moment må utføres for å få karakter.",
                "Feil moment, eller ett mistet moment, gir høyst 7.",
                "Hunden mister et moment hvis den beveger seg mer enn én kroppslengde etter kommandoen.",
                "Du skal ikke snu deg for å se på hunden."
            ]
        ),
        LPExercise(
            number: "3.4", title: "Innkalling fra dekk med dekk", coefficient: 3,
            summary: "Innkalling over 20 meter, hvor hunden legges ned underveis.",
            commands: ["Dekk", "Kom"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du kommanderer «dekk»."),
                .order("Du går ca. 20 meter fra hunden og gjør helt om og holdt på anvist plass."),
                .order("Du kaller inn hunden («kom»)."),
                .info("Før hunden har passert halve distansen, kommanderer du «dekk»."),
                .order("Du kaller inn hunden til utgangsstilling.")
            ],
            judging: [
                "Hunden skal komme villig, ta korteste vei og holde minst hurtig trav.",
                "Hunden må stoppe minst 5 meter fra deg for at dekkmomentet godkjennes.",
                "Adlyder ikke hunden dekk innenfor 3 kroppslengder, underkjennes øvelsen.",
                "En tredje kommando på et moment underkjenner øvelsen."
            ]
        ),
        LPExercise(
            number: "3.5", title: "Fremadsending med dekk og på plass", coefficient: 4,
            summary: "Du sender hunden 20 meter til ruta og legger den ned. Du går en rute, og kaller hunden inn under marsj.",
            commands: ["Fremad", "(Stå)", "Dekk", "Kom"],
            steps: [
                .info("Før øvelsen sier du fra til dommeren om du vil bruke «stå» før «dekk» i ruta, eller direkte «dekk»."),
                .info("Ruta ligger ca. 20 meter fra start. Du skal ikke vise hunden retning eller rute."),
                .order("Du sender hunden inn i ruta («fremad»)."),
                .info("Du kommanderer «dekk» (eventuelt «stå» først) når hunden er i ruta."),
                .order("Du går mot høyre fremre kjegle."),
                .order("Ca. 2 meter fra kjeglen får du beskjed om å vende til venstre."),
                .order("Etter ca. 3 meter får du beskjed om å vende til venstre igjen, tilbake mot utgangspunktet."),
                .order("Ca. 10 meter etter den andre vendingen kommanderer du hunden til fot-posisjon under marsj. Du fortsetter mot startpunktet."),
                .order("Du gjør holdt ved startpunktet.")
            ],
            judging: [
                "Viser du hunden retning eller berører den ved start, underkjennes øvelsen. En «touch» er tillatt.",
                "Maks 4 kommandoer for høyeste karakter.",
                "Setter eller reiser hunden seg før din andre vending, underkjennes øvelsen.",
                "Hele hunden (unntatt halen) må være innenfor ruta."
            ]
        ),
        LPExercise(
            number: "3.6", title: "Apportering med dirigering", coefficient: 3,
            summary: "Hunden sendes til en sirkel, stoppes, og dirigeres så til riktig apport av to.",
            commands: ["Fot", "Stå", "Apport", "Slipp"],
            steps: [
                .info("Dommeren avgjør om høyre eller venstre apport skal hentes, lik for alle."),
                .info("Start i utgangsstilling vendt mot sirkelens senter (kjegle, 2 meters radius), ca. 5 meter unna."),
                .info("Konkurranselederen legger ut to apporter på rad, med 10 meter mellom."),
                .order("Du sender hunden til sirkelen."),
                .info("Du kommanderer «stå» i sirkelen. Alle fire bein skal være innenfor."),
                .order("Etter ca. 3 sekunder dirigerer du hunden mot riktig apport og kommanderer «apport» umiddelbart etter."),
                .info("Hunden henter apporten raskt og bringer den til deg."),
                .order("Du kommanderer «slipp» (avlevering).")
            ],
            judging: [
                "Villighet til å følge dirigering, tempo og korteste vei.",
                "Tar hunden feil apport, underkjennes øvelsen.",
                "Dirigeres hunden til riktig apport uten stopp, er høyeste karakter 8.",
                "Viser du retning eller berører hunden ved start, underkjennes øvelsen."
            ]
        ),
        LPExercise(
            number: "3.7", title: "Neseprøve", coefficient: 3,
            summary: "Hunden skal finne og apportere din merkede gjenstand blant fem andre.",
            commands: ["Bli eller fot", "Apport", "Avlever"],
            steps: [
                .info("Du får utlevert din merkede gjenstand og holder den ca. 10 sekunder. Hunden får ikke snuse på den."),
                .order("Du leverer gjenstanden til utlegger. Den legges ut sammen med 5 uberørte, ca. 10 meter unna."),
                .order("Du gjør helt om. Du velger selv om hunden får se utleggingen."),
                .order("Du kommanderer hunden til å søke opp og apportere riktig gjenstand («apport»)."),
                .info("Hunden får jobbe i ca. 1 minutt hvis den jobber aktivt og målrettet."),
                .info("Hunden avleverer til deg på kommando («avlever»).")
            ],
            judging: [
                "Hundens arbeidsvilje og tempo.",
                "Berører eller snuser hunden på gjenstanden før den leveres, underkjennes øvelsen.",
                "Feil gjenstand én gang gir høyst 7. To ganger underkjenner.",
                "Avleverer hunden feil gjenstand eller flere, underkjennes øvelsen."
            ]
        ),
        LPExercise(
            number: "3.8", title: "Kontroll over hunden på avstand", coefficient: 4,
            summary: "Hunden skifter stilling seks ganger fra 10 meters avstand.",
            commands: ["Dekk", "Utgangsstilling", "Stå", "Sitt"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du kommanderer «dekk»."),
                .order("Du forlater hunden og går til anvist plass ca. 10 meter unna."),
                .order("Konkurranselederen viser når hver stillingsforandring skal skje. Hunden skifter stilling 6 ganger (stå, sitt og dekk), og hver stilling holdes ca. 3 sekunder."),
                .info("Siste stilling skal være dekk."),
                .order("Du går inntil hunden."),
                .order("Du kommanderer «utgangsstilling».")
            ],
            judging: [
                "Hurtighet og tydelighet i stillingene, og hvor lite hunden flytter seg.",
                "For å bli godkjent må hunden skifte stilling minst 4 ganger.",
                "Flytter hunden seg mer enn 2 kroppslengder, underkjennes øvelsen.",
                "Én ekstra kommando på en stilling gir høyst 8."
            ]
        ),
        LPExercise(
            number: "3.9", title: "Fremadsending rundt kjegler, stopp og hoppe et hinder", coefficient: 3,
            summary: "Hunden sendes rundt kjegler, stoppes, og hopper så det hinderet dommeren velger.",
            commands: ["Rundt", "Stå", "Høyre/venstre", "Hopp"],
            steps: [
                .info("Det er trukket om hunden skal hoppe det åpne eller det lukkede hinderet. Du får vite det først etter at hunden har stoppet."),
                .info("Kjeglegruppen (3–6 kjegler) står ca. 10 meter fra midtpunktet mellom hindrene."),
                .order("Du sender hunden rundt kjeglene («rundt»)."),
                .info("Du kommanderer «stå» når hunden har rundet kjeglene med minst 2 meter."),
                .order("Etter ca. 3 sekunder sier konkurranselederen «åpent/lukket hinder … kommander»."),
                .info("Du kommanderer hunden til å hoppe riktig hinder («hopp», «høyre/venstre»). Hunden returnerer og tar selv utgangsstilling.")
            ],
            judging: [
                "Viser du retning eller tar på hunden ved start, underkjennes øvelsen.",
                "Hopper hunden hinder på vei ut til kjeglene, underkjennes øvelsen.",
                "Stoppkommando før 2-meters merket underkjenner øvelsen.",
                "Går hunden mellom kjeglene, er høyeste karakter 7."
            ]
        ),
        LPExercise(
            number: "3.10", title: "Helhetsinntrykk", coefficient: 2,
            summary: "Dommerens samlede inntrykk av samarbeidet gjennom hele konkurransen.",
            commands: [],
            steps: [
                .info("Vurderes underveis og mellom øvelsene."),
                .info("Maks poengsum i klassen: 320.")
            ],
            judging: [
                "Samarbeid mellom hund og fører, arbeidsvilje og arbeidsglede.",
                "Rasens temperament tas hensyn til."
            ]
        )
    ]

    static let fci3: [LPExercise] = [
        LPExercise(
            number: "FCI 3.1", title: "Felles sitt 2 min med skjult fører", coefficient: 2,
            summary: "Kombinert med 3.2. Hundene sitter i 2 minutter mens førerne er ute av syne.",
            commands: ["Sitt", "(Bli)"],
            steps: [
                .info("Hundene går inn i ringen uten line, men med halsbånd. Grupper på 3–4 hunder."),
                .info("Førerne står på rad med ca. 4–5 meter mellom seg. Hundene sitter i utgangsstilling."),
                .order("Konkurranselederen annonserer «Øvelse 3.1 starter»."),
                .order("Du forlater hunden og går ut av syne. Dere er skjult i 2 minutter, og tiden starter når alle er ute av syne."),
                .order("Du går tilbake til ringen."),
                .order("Du går til anvist plass ca. 10 meter fra hundene og gjør holdt, vendt mot dem."),
                .order("Konkurranselederen annonserer «Øvelse 3.1 slutter. Øvelse 3.2 starter».")
            ],
            judging: [
                "Karakterene gis separat for 3.1 og 3.2, ved slutten av begge øvelsene.",
                "Hunder som har skiftet posisjon under 3.1 må kommanderes til sitt før 3.2."
            ]
        ),
        LPExercise(
            number: "FCI 3.2", title: "Felles dekk 1 minutt med innkalling", coefficient: 2,
            summary: "Følger rett etter 3.1. Hundene legges ned i 1 minutt, og kalles deretter inn én og én.",
            commands: ["Dekk", "Kom", "(Fot)"],
            steps: [
                .info("Hundene skal sitte på rad på sin opprinnelige plass. Hunder som har skiftet posisjon under 3.1, kommanderes til «sitt» først, én etter én fra høyre mot venstre."),
                .order("Du kommanderer hunden til å legge seg («dekk»). Dette gjøres én og én, fra venstre mot høyre."),
                .info("Hundene ligger i 1 minutt."),
                .order("Du kaller inn hunden til utgangsstilling («kom»). Dette gjøres én og én, fra høyre mot venstre, på konkurranselederens kommando.")
            ],
            judging: [
                "Ikke kommander for høyt: det kan påvirke de andre hundene og gir sterkt trekk.",
                "Hunden som ikke legger seg eller endrer posisjon, mislykkes i øvelsen."
            ]
        ),
        LPExercise(
            number: "FCI 3.3", title: "Fri ved fot", coefficient: 4,
            summary: "Fri ved fot i alle gangarter, med vendinger, forflytninger og lang baklengsgange. Gjennomføres sammen med 3.4.",
            commands: ["Fot"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Du kommanderer «fot» og går vanlig marsj, sakte marsj og springmarsj i forbindelse med vendinger og holdt. Det bør være tydelig tempoforskjell mellom vanlig og sakte, og mellom vanlig og springmarsj."),
                .order("Du går noen få skritt i ulike retninger fra utgangsstilling, og gjør vendinger fra utgangsstilling."),
                .order("Du går baklengs ca. 5–10 meter (15–30 skritt) fra utgangsstilling og til utgangsstilling. Baklengs gange skal inkludere en vending til venstre eller høyre. Konkurranselederen kommanderer start, vending og stopp."),
                .info("3.3 og 3.4 bør til sammen ikke ta mer enn ca. 4½ minutt.")
            ],
            judging: [
                "Hunden som forlater deg eller holder mer enn en halv meter avstand store deler av øvelsen, mislykkes.",
                "Hund som henger etter er en stor feil: 2–5 karakterer.",
                "Unaturlige bevegelser og overdrivelser, hos både hund og fører, er store feil.",
                "Bevegelsen skal være naturlig. Hunden som ser opp på deg på en overdreven måte trekkes."
            ]
        ),
        LPExercise(
            number: "FCI 3.4", title: "Momenter under marsj, med innkalling", coefficient: 3,
            summary: "To momenter (stå, sitt eller dekk) under marsj. Ett av momentene inkluderer innkalling.",
            commands: ["Fot", "Stå / Sitt / Dekk", "Kom"],
            steps: [
                .info("Dommeren bestemmer før konkurransen hvilke to momenter (stå, sitt eller dekk), rekkefølgen og hvor innkallingen skal være. Alle deltakere gjør det samme."),
                .order("Konkurranselederen annonserer «Øvelse 3.4 starter». Du starter fra utgangsstilling."),
                .order("Etter en kort marsj får du beskjed om å kommandere første moment. Du forlater hunden og fortsetter marsjen alene."),
                .order("Du dirigeres til venstresving, høyresving, helt om og/eller holdt, eller til å kalle inn hunden, avhengig av programmet."),
                .order("Du returnerer til hunden eller kaller den inn."),
                .order("Etter en kort fri ved fot får du beskjed om å ta neste moment."),
                .order("Du gjør holdt. Konkurranselederen annonserer «Øvelse 3.4 er ferdig».")
            ],
            judging: [
                "Alle deler utføres på kommando fra konkurranselederen.",
                "En andre kommando på momentet gjør momentet mislykket."
            ]
        ),
        LPExercise(
            number: "FCI 3.5", title: "Innkalling med stå/sitt/dekk", coefficient: 3,
            summary: "Innkalling over 30–35 meter med to stopp underveis.",
            commands: ["Dekk", "(Bli)", "Kom", "Stå / Sitt / Dekk"],
            steps: [
                .info("Dommeren velger to av momentene stå, sitt og dekk, og rekkefølgen."),
                .order("Du kommanderer hunden til å legge seg ved startpunktet («dekk»), går 30–35 meter i angitt retning og gjør helt om og holdt."),
                .order("Du kaller inn hunden («kom»)."),
                .info("Ved ⅓ av avstanden kommanderer du første moment. Du kommanderer på eget initiativ når hunden er på nivå med markøren."),
                .order("Etter ca. 3 sekunder kaller du inn hunden igjen."),
                .info("Ved ⅔ av avstanden kommanderer du andre moment, på eget initiativ."),
                .order("Du kaller hunden til utgangsstilling.")
            ],
            judging: [
                "Hunden skal reagere villig og holde minst hurtig trav.",
                "Trege bevegelser og avventing i momentene er feil.",
                "En ekstra innkalling trekker 2 poeng."
            ]
        ),
        LPExercise(
            number: "FCI 3.6", title: "Fremadsending med dirigering, dekk og på plass", coefficient: 4,
            summary: "Hunden sendes til en sirkel, stoppes, dirigeres til en rute og legges ned, og kalles så inn.",
            commands: ["Fremover", "Stå", "Høyre/venstre", "Dekk", "Kom"],
            steps: [
                .info("Før øvelsen sier du fra til dommeren om du vil bruke «stå» før «dekk» i ruta, eller direkte «dekk»."),
                .info("Sirkelen har 2 meters radius og ligger ca. 10 meter fra start. Ruta er 3×3 meter og ligger ca. 25 meter fra start."),
                .order("Du sender hunden inn i sirkelen («fremover») og kommanderer «stå» når den er inne."),
                .order("Etter ca. 3–4 sekunder dirigerer du hunden til ruta («høyre/venstre») på instruksjon fra konkurranselederen."),
                .info("Når hunden når ruta, kommanderer du «dekk» (eller «stå» og deretter «dekk») på eget initiativ."),
                .order("På kommando fra konkurranselederen går du mot hunden. Ca. 2 meter fra hunden vender du 90°, og etter ca. 10 meter vender du igjen."),
                .order("Du går mot startpunktet. Etter ytterligere ca. 10 meter blir du bedt om å kalle inn hunden («kom») mens du fortsetter å gå."),
                .order("Du stopper ved startpunktet.")
            ],
            judging: [
                "Står hunden på grensen av sirkelen, kan du sende videre, men karakteren reduseres.",
                "Er hunden helt utenfor sirkelen, må den dirigeres inn, ellers mislykkes øvelsen.",
                "Hunden skal ikke stoppe eller legge seg uten kommando."
            ]
        ),
        LPExercise(
            number: "FCI 3.7", title: "Apport med dirigering", coefficient: 3,
            summary: "Hunden sendes mot midterste av tre apporter, stoppes, og dirigeres til venstre, midterste eller høyre.",
            commands: ["Frem", "Stå", "Høyre/venstre/midten/apport", "Slipp"],
            steps: [
                .info("Tre tre-apporter ligger på rad med ca. 5 meter mellom. Startpunktet er ca. 20 meter fra den midterste."),
                .info("Hvilken apport som skal hentes avgjøres ved loddtrekning."),
                .order("Du sender hunden mot den midterste apporten («frem») på konkurranselederens kommando."),
                .info("Etter at hunden har passert 10-meterslinjen kommanderer du «stå». Hunden skal stoppe før apportlinjen."),
                .order("Etter ca. 3 sekunder får du vite hvilken apport (venstre, midterst eller høyre) som skal hentes: «venstre/midterst/høyre … kommander»."),
                .info("Du dirigerer hunden og kommanderer «apport» uten pause etter retningskommandoen."),
                .info("Hunden henter apporten og leverer den til deg («slipp»).")
            ],
            judging: [
                "Stopper hunden før 10-meterslinjen, må den omdirigeres, og det reduserer karakteren.",
                "For den midterste apporten kan du sette hendene sammen foran deg og peke."
            ]
        ),
        LPExercise(
            number: "FCI 3.8", title: "Fremadsending rundt kjegler, stå/sitt/dekk, apportering og hopp", coefficient: 4,
            summary: "Hunden sendes rundt kjegler, stoppes, og henter så apport til høyre eller venstre og hopper det tilhørende hinderet.",
            commands: ["Rundt", "Stå / Sitt / Dekk", "Høyre/venstre/apport", "(Hopp)", "Slipp"],
            steps: [
                .info("Dommeren informerer før konkurransen om hvilken posisjon (stå, sitt eller dekk) hunden skal ta på vei tilbake."),
                .info("To åpne hinder står ca. 5 meter fra hverandre. Kjeglene står ca. 15 meter fra linjen mellom hindrene."),
                .order("Konkurranselederen annonserer starten. Du sender hunden rundt kjeglene («rundt») på kommando."),
                .info("Når hunden er på vei tilbake og har passert kjeglene med minst 2 meter, kommanderer du den til å stoppe i riktig posisjon."),
                .order("Etter ca. 3 sekunder sier konkurranselederen «høyre/venstre … kommander». Du må vente på «kommander»."),
                .info("Du kommanderer hunden til å hente riktig apport, hoppe over riktig hinder og returnere til utgangsstilling.")
            ],
            judging: [
                "Høyde på hindrene: hundens skulderhøyde, maks 60 cm.",
                "Apportene plasseres alltid i samme rekkefølge i hele konkurransen."
            ]
        ),
        LPExercise(
            number: "FCI 3.9", title: "Neseprøve", coefficient: 3,
            summary: "Hunden skal finne din merkede gjenstand blant 5–7 andre og apportere den.",
            commands: ["(Bli / Fot)", "Søk", "Slipp"],
            steps: [
                .info("Start i utgangsstilling."),
                .order("Konkurranselederen annonserer «øvelsen starter» og gir deg gjenstanden (10×2×2 cm). Du holder den ca. 5 sekunder."),
                .order("Du leverer gjenstanden og snur deg. Du velger selv om hunden får se utleggingen."),
                .order("Konkurranselederen legger den ut sammen med 5–7 lignende gjenstander, ca. 10 meter unna."),
                .order("Du gjør helt om og kommanderer hunden til å søke opp og apportere den merkede gjenstanden («søk»)."),
                .info("Hunden får jobbe i ca. et halvt minutt hvis den jobber aktivt og målrettet."),
                .info("Hunden avleverer til deg på kommando («slipp»).")
            ],
            judging: [
                "Øvelsen mislykkes hvis hunden får lukte eller berøre gjenstanden i starten, eller hvis den plukker opp feil gjenstand.",
                "Kommandoer når hunden er ute ved gjenstandene gir 0."
            ]
        ),
        LPExercise(
            number: "FCI 3.10", title: "Kontroll over hunden på avstand", coefficient: 4,
            summary: "Hunden skifter stilling seks ganger (hver stilling to ganger) fra 15 meters avstand.",
            commands: ["Dekk", "(Bli)", "Sitt / Stå / Dekk", "Sitt"],
            steps: [
                .info("Startpunktet ligger mellom to markører ca. 1 meter fra hverandre."),
                .order("Du kommanderer hunden til å legge seg ved startpunktet («dekk»)."),
                .order("Du forlater hunden og går til anvist sted ca. 15 meter unna, og snur deg mot hunden."),
                .order("Konkurranselederen viser når hver stillingsforandring skal skje, ca. hvert 3. sekund. Sitt, stå og dekk utføres to ganger hver, og siste stilling skal være dekk."),
                .order("Du går tilbake til hunden."),
                .order("Du kommanderer «sitt».")
            ],
            judging: [
                "Hurtighet og nøyaktighet i stillingsforandringene.",
                "Håndsignaler må være korte og samtidige med den verbale kommandoen."
            ]
        )
    ]
}
