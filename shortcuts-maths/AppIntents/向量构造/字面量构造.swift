//
//  MathsBuildVec.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents

struct VecBuildLiteral: AppIntent {
    static let title: LocalizedStringResource = "Vector: Create literal"
    static let description = IntentDescription(
        "Create a Nx1 vector.",
        resultValueName: "Vector"
    )
    
    @Parameter(
        title: "Vector literal",
        inputOptions: .init(
            keyboardType: .numbersAndPunctuation,
            capitalizationType: .none,
            multiline: true, autocorrect: false,
            smartQuotes: false, smartDashes: false
        )
    ) var input: String
    
    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
//        let splitted = input.split {
//            $0 == "," || $0 == " " || $0 == ";" || $0 == "\n"
//        }
//        let mapped: [Double?] = splitted
//            .map { Double($0) }.filter { $0 != nil }
//        let result: [Double] = mapped.map { $0 ?? 0.0 }
//        return .result(value: result)
        let vec = input
            .components(separatedBy: CharacterSet(charactersIn: ", ; \n"))
            .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        return .result(value: VectorEntity(vec))
    }
}
