import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/expense_db.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = "Food";

  final List<String> categories = [
    "Food",
    "Transport",
    "Education",
    "Hostel",
    "Entertainment",
  ];

  Future<void> _saveExpense() async {
    if (_amountController.text.isEmpty) return;

    final expense = Expense(
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      note: _noteController.text,
      date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    );

    await ExpenseDB.insertExpense(expense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: categories.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
              decoration: const InputDecoration(labelText: "Category"),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: "Note"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveExpense, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
