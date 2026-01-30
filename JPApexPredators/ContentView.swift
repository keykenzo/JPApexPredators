//
//  ContentView.swift
//  JPApexPredators
//
//  Created by Mario Duarte on 27/01/26.
//

import SwiftUI
import MapKit

struct ContentView: View {
	let predators = Predators()
	
	@State var searchText = ""
	@State var alphabetical = false
	@State var currentSelection = ApexPredator.APType.all
	
	var filteredDinos: [ApexPredator] {

		predators.filter(by: currentSelection)
		
		predators.sort(by: alphabetical)
		
//		var result = predators.search(for: searchText)
//		
//		if currentSelection != .all {
//			result = result.filter {
//				$0.type == currentSelection
//			}
//		return result
//	 }
		
		return predators.search(for: searchText)
	}
	
    var body: some View {
		NavigationStack {
			List(filteredDinos) { predator in
				NavigationLink {
					PredatorDetail(predator: predator, position: .camera(
						MapCamera(
				   centerCoordinate:
					   predator.location, distance: 30000
				  )))
				} label: {
					HStack{
						//Dinosaur Image
						Image(predator.image)
							.resizable()
							.scaledToFit()
							.frame(width: 100, height: 100)
							.shadow(color: .white, radius: 1)
						
						VStack (alignment: .leading){
							//Name
							Text(predator.name)
								.fontWeight(.bold)
							
							//Type
							Text(predator.type.rawValue.capitalized)
								.font(.subheadline)
								.fontWeight(.semibold)
								.padding(.horizontal)
								.padding(.vertical,5)
								.background(predator.type.background)
								.clipShape(.capsule)
						}
						
					}
					
				}
				
			}
			.navigationTitle("Apex Predators")
//			.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
			.searchable(text: $searchText) //##novo searchable
			.autocorrectionDisabled()
			.animation(.default, value: searchText)
			.toolbar{
				ToolbarItem(placement: .topBarLeading){
					Button{
						withAnimation {
							alphabetical.toggle()
						}
					} label: {
						if alphabetical{
							Image(systemName: "film")
						} else{
							Image(systemName: "textformat")
						}
					}
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Menu {
						Picker("Filter", selection: $currentSelection.animation()){
							ForEach(ApexPredator.APType.allCases) { type in
								Label(type.rawValue.capitalized, systemImage: type.icon)
							}
						}
					} label: {
						Image(systemName: "slider.horizontal.3")
					}
				}
			}
		}
		.preferredColorScheme(.dark)
    }
	
}

#Preview {
    ContentView()
}
