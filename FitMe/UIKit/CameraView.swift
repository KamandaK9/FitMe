//
//  CameraView.swift
//  FitMe
//
//  Created by Daniel Senga on 2023/03/02.
//

import AVFoundation
import UIKit


final class CameraView: UIView {
	override class var layerClass: AnyClass {
		AVCaptureVideoPreviewLayer.self
	}
	var previewLayer: AVCaptureVideoPreviewLayer {
		layer as! AVCaptureVideoPreviewLayer
	}
}
