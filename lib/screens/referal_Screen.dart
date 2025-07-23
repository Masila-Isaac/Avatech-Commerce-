import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample static data (replace with your DB fetch logic)
    final List<Map<String, String>> referrals = [
      {
        'phone': '+254 71234 56789',
        'name': 'User One',
        'joined': 'JULY 15 2025, 06:00 AM',
        'status': 'Active',
      },
      {
        'phone': '+254 71234 56780',
        'name': 'User Two',
        'joined': 'JULY 21 2025, 12:00 AM',
        'status': 'Active',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Your Referrals"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReferralProgress(active: 2, pending: 0, inactive: 0),
            const SizedBox(height: 16),
            _buildShareInvite(context),
            const SizedBox(height: 16),
            _buildReferralList(referrals),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralProgress({
    required int active,
    required int pending,
    required int inactive,
  }) {
    final total = active + pending + inactive;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Referral Progress",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Active Referrals",
                style: TextStyle(color: Colors.white70),
              ),
              Text("$total/10", style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: total / 10,
            backgroundColor: Colors.grey.shade700,
            color: Colors.deepPurpleAccent,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _progressChip("Active", active, Colors.green),
              _progressChip("Pending", pending, Colors.orange),
              _progressChip("Inactive", inactive, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressChip(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildShareInvite(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Share & Invite",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "ISAAC2024",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text("Share Link"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: "ISAAC2024"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Referral code copied!"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                color: Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReferralList(List<Map<String, String>> referrals) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Referrals (${referrals.length})",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...referrals.map((ref) => _referralTile(ref)),
        ],
      ),
    );
  }

  Widget _referralTile(Map<String, String> ref) {
    return Card(
      color: const Color(0xFF2C2C2C),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.phone, color: Colors.deepPurpleAccent),
        title: Text(ref['phone']!, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          "${ref['name']} \nJoined ${ref['joined']}",
          style: const TextStyle(color: Colors.white60),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: ref['status'] == 'Active' ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            ref['status']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
