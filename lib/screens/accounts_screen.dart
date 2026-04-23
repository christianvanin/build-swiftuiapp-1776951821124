import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final WalletService _walletService = WalletService();
  String _balance = "0,00 €";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final balance = await _walletService.getFormattedBalance();
    if (!mounted) return;
    setState(() {
      _balance = balance;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF0070E0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPayPalBalanceCard(),
            const SizedBox(height: 24),
            const Text(
              'Conti bancari e carte',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001C64),
              ),
            ),
            const SizedBox(height: 12),
            _buildBanksAndCardsList(),
            const SizedBox(height: 24),
            const Text(
              'Preferenze',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001C64),
              ),
            ),
            const SizedBox(height: 12),
            _buildPreferencesList(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPayPalBalanceCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF001C64),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'P',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Saldo PayPal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF001C64),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  const SizedBox(
                    height: 38,
                    child: CircularProgressIndicator(),
                  )
                else
                  Text(
                    _balance,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001C64),
                      letterSpacing: -1,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanksAndCardsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildListItem(
            icon: Icons.account_balance,
            iconColor: const Color(0xFF0070E0),
            iconBgColor: const Color(0xFFE5F1FB),
            title: 'Intesa Sanpaolo',
            subtitle: 'Conto corrente •••• 4092',
          ),
          Divider(height: 1, color: Colors.grey[200], indent: 64),
          _buildListItem(
            customIcon: _buildMastercardLogo(),
            iconBgColor: Colors.grey[100],
            title: 'Mastercard',
            subtitle: 'Carta di debito •••• 8123',
          ),
          Divider(height: 1, color: Colors.grey[200], indent: 64),
          _buildListItem(
            customIcon: _buildVisaLogo(),
            iconBgColor: Colors.grey[100],
            title: 'Visa',
            subtitle: 'Carta di credito •••• 1945',
          ),
          Divider(height: 1, color: Colors.grey[200]),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE5F1FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Color(0xFF0070E0)),
            ),
            title: const Text(
              'Collega un conto bancario o una carta',
              style: TextStyle(
                color: Color(0xFF0070E0),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.language, color: Color(0xFF001C64)),
            ),
            title: const Text(
              'Acquisti online',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF001C64),
              ),
            ),
            subtitle: Text(
              'Mastercard •••• 8123',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          Divider(height: 1, color: Colors.grey[200], indent: 64),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.storefront, color: Color(0xFF001C64)),
            ),
            title: const Text(
              'Acquisti in negozio',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF001C64),
              ),
            ),
            subtitle: Text(
              'Saldo PayPal',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    IconData? icon,
    Widget? customIcon,
    Color? iconColor,
    Color? iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBgColor ?? Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: customIcon ?? Icon(icon, color: iconColor ?? const Color(0xFF001C64)),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF001C64),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildMastercardLogo() {
    return SizedBox(
      width: 28,
      height: 18,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisaLogo() {
    return const Text(
      'VISA',
      style: TextStyle(
        color: Color(0xFF1A1F71),
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: 12,
      ),
    );
  }
}
