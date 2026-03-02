//
//  求逆.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents
import Accelerate

struct InverseIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Inverse"
    static var description = IntentDescription(
        "Inverse the vector.",
        resultValueName: "Inversed"
    )
    
    @Parameter(title: "Vector") var vector: VectorEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Inverse of \(\.$vector)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        let v = vector.elements, c = v.count
        if v.isEmpty { throw VectorError.emptyVector }
        var result = [Double](repeating: 0, count: c)
        var n = Int32(c)
        var ones = [Double](repeating: 1.0, count: c)
        vvdiv(&result, &ones, v, &n)
        return .result(value: VectorEntity(result))
    }
}
