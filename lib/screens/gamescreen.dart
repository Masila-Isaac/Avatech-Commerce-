import 'package:flutter/material.dart';
import 'package:tempo/screens/Homescreen.dart';

class GuessingGameScreen extends StatefulWidget {
  const GuessingGameScreen({super.key});

  @override
  State<GuessingGameScreen> createState() => _GuessingGameScreenState();
}

class _GuessingGameScreenState extends State<GuessingGameScreen> {
  bool _hasDeposited = false;
  String _selectedGuess = '';
  String _resultMessage = '';
  bool _isProcessing = false;

  final List<int> _luckyNumbers = [1, 2, 4, 8];
  final int _entryFee = 50;
  final int _prizeAmount = 1000;

  Future<void> _handleDeposit() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _hasDeposited = true;
      _resultMessage = "✅ Deposited Ksh.$_entryFee! Select your number";
      _isProcessing = false;
    });
  }

  Future<void> _handleGuess() async {
    if (!_hasDeposited) {
      _showErrorDialog(
        "Deposit Required",
        "💰 Please deposit Ksh.$_entryFee to play!",
      );
      return;
    }

    if (_selectedGuess.isEmpty) {
      _showErrorDialog("No Number Selected", "❗ Please select a number first!");
      return;
    }

    final int? guess = int.tryParse(_selectedGuess);
    if (guess == null) {
      _showErrorDialog("Invalid Input", "❗ Please enter a valid number!");
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final bool isWinner = _luckyNumbers.contains(guess);

    _showResultDialog(
      isWinner ? "Congratulations!" : "Better Luck Next Time",
      isWinner
          ? "🎉 You WON Ksh.$_prizeAmount!"
          : "❌ Not a lucky number. Try again!",
      isWinner,
    );

    setState(() {
      _hasDeposited = false;
      _selectedGuess = '';
      _resultMessage = '';
      _isProcessing = false;
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  void _showResultDialog(String title, String message, bool isWinner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(
              isWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              color: isWinner ? Colors.amber : Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              if (isWinner && mounted) {
                await Future.delayed(const Duration(milliseconds: 300));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Homescreen()),
                );
              }
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.blueAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (value == '❌') {
        _selectedGuess = '';
      } else if (value == '🔙') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Homescreen()),
        );
      } else {
        // Allow any single digit selection (0-9)
        if (_selectedGuess.isEmpty && value.length == 1) {
          _selectedGuess = value;
        }
      }
    });
  }

  Widget _buildKeypadButton(String label) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _onKeyPressed(label),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.blueGrey[700],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 2),
                blurRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        _buildKeypadButton('1'),
        _buildKeypadButton('2'),
        _buildKeypadButton('3'),
        _buildKeypadButton('4'),
        _buildKeypadButton('5'),
        _buildKeypadButton('6'),
        _buildKeypadButton('7'),
        _buildKeypadButton('8'),
        _buildKeypadButton('9'),
        _buildKeypadButton('❌'),
        _buildKeypadButton('0'),
        _buildKeypadButton('🔙'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGuessValid = _selectedGuess.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Icon(Icons.casino, color: Colors.amber, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Number Guessing Game",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How To Play:",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...[
                          "1. Deposit Ksh.$_entryFee to play",
                          "2. Select any number between 0-9",
                          "3. If your number is lucky, win Ksh.$_prizeAmount!",
                        ].map(
                          (text) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "• ",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (!_hasDeposited)
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _handleDeposit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.attach_money),
                              const SizedBox(width: 8),
                              Text(
                                "Deposit Ksh.$_entryFee",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                if (_hasDeposited && _resultMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      _resultMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.greenAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Your Number:",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedGuess.isEmpty
                              ? "No number selected"
                              : _selectedGuess,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (isGuessValid && !_isProcessing)
                          ElevatedButton(
                            onPressed: _handleGuess,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[800],
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildKeypad(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
