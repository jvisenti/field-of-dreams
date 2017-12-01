//
//  CityField.swift
//  FieldofDreams
//
//  Created by Rob Visentin on 12/1/17.
//

import Foundation
import ARKit

struct CityField: Field {
    var unit: UnitLength = .inches
    var verticies: [Point] = [(0,0)]
    var lines: [Line] = []
}
