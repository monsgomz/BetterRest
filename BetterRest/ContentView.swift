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
	
	@State private var wakeUp = defaultWakeTime
	@State private var sleepAmount = 8.0
	@State private var coffeeAmount = 1
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showingAlert = false
	//el valor va a estar solo para la vista, no para cada instancia
	//podemos ller la variable en cualquier lado porque no depende de otras cosas
	static var defaultWakeTime: Date {
		var components = DateComponents()
		components.hour = 7
		components.minute = 0
		return Calendar.current.date(from: components) ?? .now
	}
	
	
    var body: some View {
		NavigationStack{
			
				Form {
					
					Section("When do you want to wake up?"){
						
						DatePicker("Please select a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
							.labelsHidden()
					}
					
					Section("Desired amount of sleep"){
						Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
					}
				
					Section("Daily coffee intake"){
						//para que ponga el plural automaticamente
						Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
					}
					
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
