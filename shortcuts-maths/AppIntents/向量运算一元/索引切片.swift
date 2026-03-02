//
//  索引切片.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.02.
//

import AppIntents
import Accelerate

struct VectorSliceIntent: AppIntent {
    static var title: LocalizedStringResource = "Vector: Slice in range"
    static var description = IntentDescription(
        "Slice the vector within the given range. Index starts at 1. -N is the last Nth.",
        resultValueName: "Slice"
    )
    
    @Parameter(title: "Vector") var vector: VectorEntity
    @Parameter(title: "Start") var iStart: Int
    @Parameter(title: "Stop") var iStop: Int

    static var parameterSummary: some ParameterSummary {
        Summary("For \(\.$vector) slice value from \(\.$iStart) to \(\.$iStop).")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<VectorEntity> {
        let v = vector.elements
        if v.isEmpty { throw VectorError.emptyVector }
        if abs(iStart) > v.count { throw VectorError.outOfBound(vec: vector, index: iStart) }
        if abs(iStop) > v.count { throw VectorError.outOfBound(vec: vector, index: iStop) }
        if iStart == 0 || iStop == 0 { throw VectorError.outOfBound(vec: vector, index: 0) }
        let start = iStart > 0 ? iStart - 1 : v.endIndex + iStart + 1
        let stop = iStop > 0 ? iStop - 1 : v.endIndex + iStop + 1
        if start > stop { throw VectorError.emptyVector }
        let slice = Array(v[start...stop])
        return .result(value: VectorEntity(slice))
    }
}
