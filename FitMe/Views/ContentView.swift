//
//  ContentView.swift
//  FitMe
//
//  Created by Daniel Senga on 2023/03/02.
//

import SwiftUI

struct ContentView: View {
	
	
    var body: some View {
		TabView {
			SquatView()
				.tabItem {
					Image(systemName: "figure.cross.training")
					Text("Squats")
				}
			
			
			
		}
		.navigationTitle("FitMe, exercise pal.")
		.navigationBarTitleDisplayMode(.automatic)
			
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
