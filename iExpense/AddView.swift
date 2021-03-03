//
//  AddView.swift
//  iExpense
//
//  Created by Sandra Quel on 3/1/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expensess: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business","Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                               Text($0)
                           }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add New Expense")
            .navigationBarItems(trailing:
                                    Button("Save") {
                                        if let actualAmount = Int(self.amount){
                                            let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                                            self.expensess.items.append(item)
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
            )
        }
        
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expensess: Expenses())
    }
}
