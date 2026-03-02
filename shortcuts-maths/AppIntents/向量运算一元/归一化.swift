//
//  归一化.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct NormalizeIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Normalize"
    static var description = IntentDescription(
        "Normalize the vector.",
        resultValueName: "Normalized"
    )
    
    @Parameter(title: "Vector") var vector: VectorEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Normalize \(\.$vector)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        let v = vector.elements
        if v.isEmpty { throw VectorError.emptyVector }
        let magnitude = sqrt(vDSP.sum(vDSP.square(v)))
        guard magnitude > 0 else { return .result(value: vector) }
        return .result(value: VectorEntity(vDSP.divide(v, magnitude)))
    }
}
