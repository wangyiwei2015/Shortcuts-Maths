//
//  VectorEnrity.swift
//  shortcuts-maths
//
//  Created by leo on 2026.03.01.
//

import AppIntents

struct VectorEntity: TransientAppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Vector"
    static var defaultQuery = VectorQuery()
    var id: UUID = UUID()
    
    @Property(title: "Element List") var elements: [Double]
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "Vector (\(elements.count) elements)", subtitle: preview)
    }
    
    var preview: LocalizedStringResource {
        if elements.isEmpty { return "Empty" }
        if elements.count < 6 {
            return "[\(elements.map { String(format: "%.2f", $0) }.joined(separator: ", "))]"
        } else {
            return "[\(elements.prefix(5).map { String(format: "%.2f", $0) }.joined(separator: ", "))\(elements.count > 5 ? "…" : "")]"
        }
    }
    
    init() { self.elements = [] }
    init(_ array: [Double]) {
        self.elements = array
    }
}

struct VectorQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [VectorEntity] { return [] }
}
