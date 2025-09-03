class Expense {
  final int? id;
  final String category;
  final double amount;
  final String note;
  final DateTime date; // ✅ Use DateTime instead of String

  Expense({
    this.id,
    required this.category,
    required this.amount,
    required this.note,
    required this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      note: map['note'],
      date: DateTime.parse(map['date']), // ✅ Convert String → DateTime
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(), // ✅ Store as String
    };
  }
}
