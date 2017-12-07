//
//  Wheel.swift
//  FieldofDreams
//
//  Created by Rob Visentin on 12/7/17.
//

import ARKit

class Wheel: VirtualObject {

    override init() {
        super.init(modelName: "wheel", fileExtension: "scn", thumbImageFilename: "wheel", title: "Wheel")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
