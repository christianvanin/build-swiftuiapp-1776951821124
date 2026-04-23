class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final String date;
  final bool isPositive;

  const Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isPositive,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Sconosciuto',
      subtitle: json['subtitle'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] as String? ?? '',
      isPositive: json['isPositive'] as bool? ?? false,
    );
  }
}
