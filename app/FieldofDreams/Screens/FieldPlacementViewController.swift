//
//  FieldPlacementViewController.swift
//  FieldofDreams
//
//  Created by Jason Clark on 7/28/17.
//

import ARKit
import Anchorage
import SceneKit

class FieldPlacementViewController: ARSceneViewController {

    var initialRotation: Float?
    var initialScale: SCNVector3?

    let field: SCNNode = {
        let field = WheelField()
        return field.node
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handle(pinch:)))
        pinch.delegate = self
        view.addGestureRecognizer(pinch)

        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handle(rotation:)))
        rotation.delegate = self
        view.addGestureRecognizer(rotation)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addChildNodeAtFocus(field)
    }

    @objc func handle(pinch: UIPinchGestureRecognizer) {
        switch pinch.state {
        case .began:
            initialScale = childNode?.scale
        case .changed:
            childNode?.scale = SCNVector3(
                x: (initialScale?.x ?? 1) * Float(pinch.scale),
                y: (initialScale?.y ?? 1) * Float(pinch.scale),
                z: (initialScale?.z ?? 1) * Float(pinch.scale)
            )
        case .ended, .cancelled, .failed:
            initialScale = nil
        default:
            break
        }
    }

    @objc func handle(rotation: UIRotationGestureRecognizer) {
        switch rotation.state {
        case .began:
            initialRotation = childNode?.eulerAngles.y
        case .changed:
            childNode?.eulerAngles.y = (initialRotation ?? 0) - Float(rotation.rotation)
        case .ended, .cancelled, .failed:
            initialRotation = nil
        default:
            break
        }
    }

}

extension FieldPlacementViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
