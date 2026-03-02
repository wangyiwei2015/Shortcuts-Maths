//
//  BuildFromList.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents

struct VecBuildList: AppIntent {
    static let title: LocalizedStringResource = "Vector: Create from List"
    static let description = IntentDescription(
        "Create a vector with input List.",
        resultValueName: "Vector"
    )
    
    @Parameter(title: "Input List") var list: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("Create Vector from \(\.$list)")
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        let values = list
            .split(whereSeparator: \.isNewline)
            .compactMap { Double(String($0).trimmingCharacters(in: .whitespaces)) }
        if values.isEmpty { throw VectorError.emptyVector }
        return .result(value: VectorEntity(values))
    }
}
