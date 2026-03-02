//
//  RMS.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct VectorRMSIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Root Mean Square"
    static var description = IntentDescription(
        "Calculates the RMS of input vector, returns scalar.",
        resultValueName: "RMS"
    )
    @Parameter(title: "Vector") var vector: VectorEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("RMS of \(\.$vector)")
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<Double> {
        if vector.elements.isEmpty { throw VectorError.emptyVector }
        var result: Double = 0
        vDSP_rmsqvD(vector.elements, 1, &result, vDSP_Length(vector.elements.count))
        return .result(value: result)
    }
}
