//
//  VectorErrors.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents

enum VectorError: LocalizedError {
    case dimensionMismatch(vecA: VectorEntity, vecB: VectorEntity)
    case emptyVector, not3D, divisionByZero
    case outOfBound(vec: VectorEntity, index: Int)
    
    var errorDescription: String? {
        switch self {
        case .dimensionMismatch(let a, let b):
            return "Dimension Mismatch: Vector A has \(a.elements.count) items, but Vector B has \(b.elements.count)."
        case .emptyVector: return "Empty vector."
        case .not3D: return "Cross product requires exactly 3 dimensions."
        case .divisionByZero: return "Cannot invert a vector containing zero."
        case .outOfBound(let v, let i):
            return "Index out of bound. The vector has \(v.elements.count) items but requesting value at \(i)."
        }
    }
}
