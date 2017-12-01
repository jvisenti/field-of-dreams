//
//  City.swift
//  FieldofDreams
//
//  Created by Rob Visentin on 12/1/17.
//

import ARKit

class City: VirtualObject {

    override init() {
        super.init(modelName: "city", fileExtension: "scn", thumbImageFilename: "city", title: "City")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
