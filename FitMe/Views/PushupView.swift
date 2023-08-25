//
//  PushupView.swift
//  FitMe
//
//  Created by Daniel Senga on 2023/08/18.
//

import SwiftUI

struct PushupView: View {
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
				Text("Push ups done:")
					.font(.title)
				Text(String(poseEstimator.pushUpCount))
					.font(.title)
				Image(systemName: "exclamationmark.triangle.fill")
					.font(.largeTitle)
					.foregroundColor(Color.red)
					.opacity(poseEstimator.wasInUpPosition ? 0.0 : 1.0)
			}
		}
		.padding(.bottom, 65)
    }
}

