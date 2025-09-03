import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/expense_db.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];
  double _total = 0;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final data = await ExpenseDB.getExpenses();
    setState(() {
      _expenses = data;
      _total = data.fold(0, (sum, e) => sum + e.amount);
    });
  }

  String formatDate(DateTime date) => DateFormat("MMM d, yyyy").format(date);

  Color getCategoryColor(String category) {
    switch (category) {
      case "Food":
        return Colors.orange.shade400;
      case "Travel":
        return Colors.blue.shade400;
      case "Shopping":
        return Colors.purple.shade400;
      case "Bills":
        return Colors.red.shade400;
      default:
        return Colors.green.shade400;
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case "Food":
        return Icons.fastfood;
      case "Travel":
        return Icons.directions_car;
      case "Shopping":
        return Icons.shopping_bag;
      case "Bills":
        return Icons.receipt_long;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("මගේ වියදම්"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Modern Summary Card with Gradient
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.teal, Colors.greenAccent],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Expenses",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "LKR ${_total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Expense List
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
                    child: Text(
                      "No expenses yet.\nTap + to add one!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      final exp = _expenses[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              getCategoryColor(exp.category).withOpacity(0.7),
                              getCategoryColor(exp.category),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              getCategoryIcon(exp.category),
                              color: getCategoryColor(exp.category),
                            ),
                          ),
                          title: Text(
                            exp.category,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            "${exp.note}\n${formatDate(exp.date)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          trailing: Text(
                            "LKR ${exp.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow.shade200,
                            ),
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
          _loadExpenses();
        },
        label: const Text("Add Expense"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
