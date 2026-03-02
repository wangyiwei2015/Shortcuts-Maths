//
//  饱和截断.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct ClampIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Threshold / Clamp"
    static var description = IntentDescription(
        "Clamps the vector.",
        resultValueName: "Clamped"
    )
    
    @Parameter(title: "Vector") var vector: VectorEntity
    @Parameter(title: "Lower Limit", default: -1.0) var lowerLimit: Double
    @Parameter(title: "Upper Limit", default: 1.0) var upperLimit: Double

    static var parameterSummary: some ParameterSummary {
        Summary("Clamp \(\.$vector) between \(\.$lowerLimit) and \(\.$upperLimit)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        let v = vector.elements
        if v.isEmpty { throw VectorError.emptyVector }
        var result = [Double](repeating: 0, count: v.count)
        // Ensure the limits are logically sound
        let low = min(lowerLimit, upperLimit)
        let high = max(lowerLimit, upperLimit)
        // vDSP_vclipD performs the clamping in a single hardware-accelerated pass
        var lowVar = low
        var highVar = high
        vDSP_vclipD(v, 1, &lowVar, &highVar, &result, 1, vDSP_Length(v.count))
        return .result(value: VectorEntity(result))
    }
}
