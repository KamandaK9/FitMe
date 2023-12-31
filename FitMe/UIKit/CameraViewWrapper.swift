//
//  CameraViewWrapper.swift
//  FitMe
//
//  Created by Daniel Senga on 2023/03/02.
//

import Foundation
import SwiftUI
import AVFoundation
import Vision

struct CameraViewWrapper: UIViewControllerRepresentable {
	var poseEstimator: PoseEstimator
	
	func makeUIViewController(context: Context) -> some UIViewController {
		let cvc = CameraViewController()
		cvc.delegate = poseEstimator
		return cvc
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		
	}
	
}
