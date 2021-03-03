//
//  ContentView.swift
//  iExpense
//
//  Created by Sandra Quel on 3/1/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let name: String
    let type: String
    let amount: Int
    let id = UUID()
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) {
                    item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                            
                        }
                        Spacer()
                        Text("$ \(item.amount)")
                        
                    }
                    .background(detemineBackgroundColor(amount: item.amount))
                }
                .onDelete(perform: removeItems(at:))
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing:
                                    Button(action: {
                                        self.showingAddExpense = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
            )
            .sheet(isPresented: $showingAddExpense) {
                //show an addview here
                AddView(expensess: self.expenses)
            }
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    func detemineBackgroundColor(amount: Int) -> Color {
        if amount < 10 {
            return .pink
        } else if amount < 100 {
            return .yellow
        } else {
            return .purple
        }
        return .clear
    }
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            
            if let decoded =  try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
