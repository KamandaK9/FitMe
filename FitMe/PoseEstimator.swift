//
//  PoseEstimator.swift
//  FitMe
//
//  Created by Daniel Senga on 2023/03/02.
//

import Foundation
import AVFoundation
import Vision
import Combine

class PoseEstimator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
	
	var wasInBottomPosition = false
	@Published var squatCount = 0
	@Published var isGoodPosture = true
	
	@Published var jumpingJackCount = 0
	@Published var wasInUpPosition = false
	
	@Published var pushUpCount = 0
	
	var subscriptions = Set<AnyCancellable>()
	
	let sequenceHandler = VNSequenceRequestHandler()
	@Published var bodyParts = [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]()
	
	override init() {
		super.init()
		$bodyParts
			.dropFirst()
			.sink(receiveValue: { bodyParts in
				self.countSquats(bodyParts: bodyParts)
				self.countJumpingJacks(bodyParts: bodyParts)
			})
			.store(in: &subscriptions)
	}
	
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		let humanBodyRequest = VNDetectHumanBodyPoseRequest(completionHandler: detectedBodyPose)
		do {
			try sequenceHandler.perform([humanBodyRequest], on: sampleBuffer, orientation: .right)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func detectedBodyPose(request: VNRequest, error: Error?) {
		guard let bodyPoseResults = request.results as? [VNHumanBodyPoseObservation] else { return }
		guard let bodyParts = try? bodyPoseResults.first?.recognizedPoints(.all) else { return }
		DispatchQueue.main.async {
			self.bodyParts = bodyParts
		}
	}
	
	func countSquats(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
		let rightKnee = bodyParts[.rightKnee]!.location
		let leftKnee = bodyParts[.rightKnee]!.location
		let rightHip = bodyParts[.rightHip]!.location
		let rightAnkle = bodyParts[.rightAnkle]!.location
		let leftAnkle = bodyParts[.leftAnkle]!.location
		
		let firstAngle = atan2(rightHip.y - rightKnee.y, rightHip.x - rightKnee.x)
		let secondAngle = atan2(rightAnkle.y - rightKnee.y, rightAnkle.x - rightKnee.x)
		var angleDiffRadians = firstAngle - secondAngle
		while angleDiffRadians < 0 {
			angleDiffRadians += CGFloat(2 * Double.pi)
		}
		let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
		if angleDiffDegrees > 150 && self.wasInBottomPosition {
			self.squatCount += 1
			self.wasInBottomPosition = false
		}
		
		let hipHeight = rightHip.y
		let kneeHeight = rightKnee.y
		if hipHeight < kneeHeight {
			self.wasInBottomPosition = true
		}
		
		
		let kneeDistance = rightKnee.distance(to: leftKnee)
		let ankleDistance = rightAnkle.distance(to: leftAnkle)
		
		if ankleDistance > kneeDistance {
			self.isGoodPosture = false
		} else {
			self.isGoodPosture = true
		}
	}
	
	func countJumpingJacks(bodyParts: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
		// Extract joint locations for the person performing the jumping jacks
		let leftShoulder = bodyParts[.leftShoulder]!.location
		let rightShoulder = bodyParts[.rightShoulder]!.location
		let leftHip = bodyParts[.leftHip]!.location
		let rightHip = bodyParts[.rightHip]!.location
		let leftAnkle = bodyParts[.leftAnkle]!.location
		let rightAnkle = bodyParts[.rightAnkle]!.location
		
		// Define a threshold value to determine positions
		let positionThreshold: CGFloat = 0.2
		
		// Check if the arms are extended and the legs are together
		let isArmsExtended = abs(leftShoulder.y - rightShoulder.y) < positionThreshold
		let isLegsTogether = abs(leftHip.x - rightHip.x) < positionThreshold && abs(leftAnkle.x - rightAnkle.x) < positionThreshold
		
		// Calculate the midpoint between the shoulders
		let shoulderMidpoint = CGPoint(x: (leftShoulder.x + rightShoulder.x) / 2, y: (leftShoulder.y + rightShoulder.y) / 2)
		
		// Check if the person is in the "up" position of the jumping jack
		let isUpPosition = isArmsExtended && isLegsTogether && shoulderMidpoint.y < leftHip.y
		
		// Increment the jumping jack count if the person transitions from the "down" to the "up" position
		if isUpPosition && !wasInUpPosition {
			jumpingJackCount += 1
			wasInUpPosition = true
		}
		
		// Set the flag to false if the person is in the "down" position
		if !isUpPosition {
			wasInUpPosition = false
		}
	}
	
	func countPushUps(bodyParts: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
		
	}


	
	
}

extension CGPoint {
	func distance(to point: CGPoint) -> CGFloat {
		return sqrt(pow(x - point.x,2) + pow(y - point.y, 2))
	}
}
