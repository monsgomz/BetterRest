//
//  ContentView.swift
//  BetterRest
//When do they want to wake up?
//Roughly how many hours of sleep do they want?
//How many cups of coffee do they drink per day?
//
//Choosing a sensible default “wake up” time.
//Reading the hour and minute they want to wake up.
//Showing their suggested bedtime neatly formatted.

//  Created by Montserrat Gomez on 2023-11-06.
//

import CoreML
import SwiftUI


struct ContentView: View {
	
	@State private var wakeUp = Date.now
	@State private var sleepAmount = 8.0
	@State private var coffeeAmount = 1
	
	
    var body: some View {
		NavigationStack{
			VStack {
				
				Text("When do you want to wake up?")
					.font(.headline)
				
				//El texto sirve para VoiceOver
				//displayed components para especificar lo que se seleccionará
				//Se puede dar un rango (one-sided ranges) solo de un lado in: Date.now...,
				
				DatePicker("Please select a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
					.labelsHidden()
				
				Text("Desired amount of sleep")
					.font(.headline)

				
				Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
				
				Text("Daily coffee intake")
					.font(.headline)
				
				Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
			
				
			}
			.navigationTitle("Better Rest")
			.toolbar {
				ToolbarItem{
					Button("Calculate", action: calculateBedtime)
				}
			}
			
		}
        
    }
	
	/// Funcion para conectar con CoreML
	func calculateBedtime() {
		
	}
}

#Preview {
    ContentView()
}
