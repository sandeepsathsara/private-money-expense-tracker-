import 'package:flutter/material.dart';
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

  final Map<String, IconData> categoryIcons = {
    "Food": Icons.fastfood,
    "Transport": Icons.directions_car,
    "Education": Icons.school,
    "Hostel": Icons.home,
    "Entertainment": Icons.movie,
  };

  final Map<String, Color> categoryColors = {
    "Food": Colors.orange.shade400,
    "Transport": Colors.blue.shade400,
    "Education": Colors.purple.shade400,
    "Hostel": Colors.green.shade400,
    "Entertainment": Colors.red.shade400,
  };

  Future<void> _saveExpense() async {
    if (_amountController.text.isEmpty) return;

    final expense = Expense(
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      note: _noteController.text,
      date: DateTime.now(),
    );

    await ExpenseDB.insertExpense(expense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Amount Input Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Amount",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField(
                    value: _selectedCategory,
                    items: categories.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Icon(categoryIcons[c], color: categoryColors[c]),
                            const SizedBox(width: 8),
                            Text(c),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCategory = val!),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Category",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Note Input Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Note",
                      prefixIcon: Icon(Icons.note),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save Button with Gradient
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                    elevation: MaterialStateProperty.all(4),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal, Colors.greenAccent.shade400],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Save Expense",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
