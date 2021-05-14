//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Antonio Vega on 5/13/21.
//

import SwiftUI

class User: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    
    @Published var name = "Antonio Vega"
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

struct ContentView: View {
    @ObservedObject var order = OrderClass()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.item.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $order.item.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.item.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $order.item.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }

                    if order.item.specialRequestEnabled {
                        Toggle(isOn: $order.item.extraFrosting) {
                            Text("Add extra frosting")
                        }

                        Toggle(isOn: $order.item.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
