import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/wallet_service.dart';
import 'accounts_screen.dart';
import 'send_request_screen.dart';
import 'history_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService _walletService = WalletService();
  
  String _balance = "0,00 €";
  String _userName = "Caricamento...";
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final balance = await _walletService.getFormattedBalance();
    final transactions = await _walletService.getTransactions();
    final name = await _walletService.getSystemUserName();

    if (!mounted) return;

    setState(() {
      _balance = balance;
      _transactions = transactions;
      _userName = name;
      _isLoading = false;
    });
  }

  String get _initials {
    if (_userName.isEmpty) return "";
    List<String> parts = _userName.split(" ");
    if (parts.length >= 2) return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    return _userName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(),
            const AccountsScreen(),
            const SendRequestScreen(),
            const HistoryScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF0070E0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Ciao, $_userName',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001C64),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              _buildAccountSetupCard(),
              const SizedBox(height: 16),
              _buildHorizontalCards(),
              const SizedBox(height: 16),
              _buildRecentActivity(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_currentIndex != 0) {
      String title = '';
      if (_currentIndex == 1) title = 'Conti';
      if (_currentIndex == 2) title = 'Invia e richiedi';
      if (_currentIndex == 3) title = 'Cronologia';

      return AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        title: Text(title, style: const TextStyle(color: Color(0xFF001C64), fontWeight: FontWeight.bold)),
        centerTitle: true,
      );
    }

    return AppBar(
      backgroundColor: const Color(0xFFF5F7FA),
      elevation: 0,
      leading: const Icon(Icons.menu, color: Color(0xFF001C64)),
      actions: [
        const Icon(Icons.grid_view, color: Color(0xFF001C64)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF001C64),
            child: Text(_initials, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSetupCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        const SizedBox(width: 48, height: 48, child: CircularProgressIndicator(value: 0.0, strokeWidth: 4)),
        const SizedBox(width: 16),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Configura il conto', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001C64))),
          Text('0 completati su 3', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ])
      ]),
    );
  }

  Widget _buildHorizontalCards() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildBalanceCard(),
          const SizedBox(width: 16),
          _buildPoolsCard(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Saldo PayPal', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001C64))),
            const SizedBox(height: 24),
            Text(_balance, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF001C64))),
          ]),
        ),
        const Spacer(),
        Container(
          decoration: const BoxDecoration(color: Color(0xFF0070E0), borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
          child: const ListTile(leading: Icon(Icons.add_card, color: Colors.white), title: Text('Ricarica il conto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        )
      ]),
    );
  }

  Widget _buildPoolsCard() {
    return Container(
      width: 200, 
      padding: const EdgeInsets.all(20), 
      decoration: BoxDecoration(color: const Color(0xFF0070E0), borderRadius: BorderRadius.circular(16)),
      child: const Text('Collette', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRecentActivity() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Attività recenti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF001C64))),
        TextButton(onPressed: () => setState(() => _currentIndex = 3), child: const Text('Vedi altro'))
      ]),
      const SizedBox(height: 16),
      if (_transactions.isEmpty) const Text('Nessuna attività') else _buildTransactionList(),
    ]);
  }

  Widget _buildTransactionList() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        itemCount: _transactions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final tx = _transactions[index];
          return ListTile(
            title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(tx.date),
            trailing: Text('${tx.isPositive ? '+' : ''}€ ${tx.amount.abs().toStringAsFixed(2)}', style: TextStyle(color: tx.isPositive ? Colors.green : Colors.black, fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0070E0),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Conti'),
        BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Invia'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Cronologia'),
      ],
    );
  }
}