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
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showingAlert = false
	
	
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
			.alert(alertTitle, isPresented: $showingAlert) {
				Button("OK") { }
			} message: {
				Text(alertMessage)
			}
			
		}
        
    }
	
	/// Funcion para conectar con CoreML
	func calculateBedtime() {
		
		do {
			let config = MLModelConfiguration()
			let model = try SleepCalculator(configuration: config)
			let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
			let hour = (components.hour ?? 0) * 60 * 60
			let minute = (components.minute ?? 0) * 60
			
			//dice cuanto tiempo debe dormir
			let prediction = try model.prediction(wake: Int64((hour + minute)), estimatedSleep: sleepAmount, coffee: Int64((coffeeAmount)))
			
			let sleepTime = wakeUp - prediction.actualSleep
			
			alertTitle = "Your ideal bedtime is…"
			alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
			
		} catch {
			alertTitle = "Error"
			alertMessage = "Sorry, there was a problem calculating your bedtime."
		}
		showingAlert = true
	}
}

#Preview {
    ContentView()
}
