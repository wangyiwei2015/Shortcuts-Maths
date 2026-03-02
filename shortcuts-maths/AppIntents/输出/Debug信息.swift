//
//  VectorDebugDesc.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents

struct VecDebugDesc: AppIntent {
    static var title: LocalizedStringResource = "Vector: Debug description"
    static var description = IntentDescription(
        "Prints the debug info of the vector.",
        resultValueName: "Debug Description"
    )
    
    @Parameter(title: "Vector") var vector: VectorEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Debug \(\.$vector)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        return .result(value: "not implemented")
    }
}
