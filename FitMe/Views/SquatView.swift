//
//  SquatView.swift
//  FitMe
//
//  Created by Daniel Senga on 2023/03/02.
//

import Foundation
import SwiftUI

struct SquatView: View {
	@StateObject var poseEstimator = PoseEstimator()
	
	var body: some View {
		VStack {
			ZStack {
				GeometryReader { geo in
					CameraViewWrapper(poseEstimator: poseEstimator)
					StickFigureView(poseEstimator: poseEstimator, size: geo.size)
				}
			}
			.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 1920 / 1080, alignment: .center)
			
			HStack {
				Text("Squat counter:")
					.font(.title)
				Text(String(poseEstimator.squatCount))
					.font(.title)
				Image(systemName: "exclamationmark.triangle.fill")
					.font(.largeTitle)
					.foregroundColor(Color.red)
					.opacity(poseEstimator.isGoodPosture ? 0.0 : 1.0)
			}
		}
		.padding(.bottom, 65)
	}
}

