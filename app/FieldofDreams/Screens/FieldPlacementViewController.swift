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

    var lastPosition: CGPoint?
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

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handle(pan:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        pan.maximumNumberOfTouches = 1

        let tap = UITapGestureRecognizer(target: self, action: #selector(handle(tap:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        tap.require(toFail: pan)
        tap.require(toFail: rotation)
        tap.require(toFail: pinch)

        let slider = UISlider()
        slider.minimumValue = Float(0.25 * WheelField().playingFieldProper)
        slider.maximumValue = Float(0.75 * WheelField().playingFieldProper)
        slider.value = Float(0.5 * WheelField().playingFieldProper)
        slider.addTarget(self, action: #selector(handle(slider:)), for: .valueChanged)

        view.addSubview(slider)
        slider.bottomAnchor == view.bottomAnchor - 20
        slider.centerXAnchor == view.centerXAnchor
        slider.widthAnchor == 0.75 * view.widthAnchor
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

    @objc func handle(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            lastPosition = pan.location(in: view)
        case .changed:
            let pos = pan.location(in: view)
            childNode?.localTranslate(by: SCNVector3(
                x: -0.01 * Float(pos.y - (lastPosition?.y ?? 0)),
                y: 0,
                z: 0.01 * Float(pos.x - (lastPosition?.x ?? 0))
            ))
            lastPosition = pan.location(in: view)
        case .ended, .cancelled, .failed:
            lastPosition = nil
        default:
            break
        }
    }

    @objc func handle(tap: UITapGestureRecognizer) {
        if tap.state == .recognized {
            addChildNodeAtFocus(field)
        }
    }

    @objc func handle(slider: UISlider) {
        let dist = Measurement<UnitLength>(value: Double(slider.value), unit: WheelField().unit)
            .converted(to: .meters)
            .value
        field.childNodes.forEach { child in
            child.position = SCNVector3(sign(child.position.x) * Float(dist), 0, child.position.z)
        }
    }

}

extension FieldPlacementViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
