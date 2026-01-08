import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../services/esp32_service.dart';

class RestScreen extends StatefulWidget {
  final ESP32Service esp32Service;

  const RestScreen({super.key, required this.esp32Service});

  @override
  State<RestScreen> createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  String _currentFace = 'happy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('REST MODE'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driveboy Face Display
            _buildFaceDisplay(),

            const SizedBox(height: 32),

            // Face Control Buttons
            const Text(
              'Change Expression',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                    child: _buildFaceButton(
                        '😊', 'Happy', 'happy', const Color(0xFF4CAF50))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildFaceButton(
                        '😴', 'Sleepy', 'sleepy', const Color(0xFF2196F3))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildFaceButton(
                        '😓', 'Tired', 'tired', const Color(0xFFFF9800))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildFaceButton(
                        '😱', 'Danger', 'danger', const Color(0xFFF44336))),
              ],
            ),
            const SizedBox(height: 12),
            // Random button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _randomFace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shuffle, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Random',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Activities
            const Text(
              'Activities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                    child: _buildActivityCard(
                  icon: '🫧',
                  title: 'Breathing',
                  subtitle: 'Calm down',
                  color: const Color(0xFF64B5F6),
                  onTap: () => _startBreathing(),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildActivityCard(
                  icon: '🧘',
                  title: 'Stretch',
                  subtitle: 'Relax',
                  color: const Color(0xFF81C784),
                  onTap: () => _startStretch(),
                )),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildActivityCard(
                  icon: '🎤',
                  title: 'Sing Together',
                  subtitle: 'Fun time',
                  color: const Color(0xFFE91E63),
                  onTap: () => _startSinging(),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildActivityCard(
                  icon: '🎯',
                  title: 'Tap Game',
                  subtitle: 'Quick fun',
                  color: const Color(0xFFFFB74D),
                  onTap: () => _startTapGame(),
                )),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildActivityCard(
                  icon: '🎨',
                  title: 'Color Match',
                  subtitle: 'Focus',
                  color: const Color(0xFFBA68C8),
                  onTap: () => _startColorMatch(),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildActivityCard(
                  icon: '🃏',
                  title: 'Memory Match',
                  subtitle: 'Brain boost',
                  color: const Color(0xFF26A69A),
                  onTap: () => _startMemoryMatch(),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceDisplay() {
    String emoji;
    String label;
    Color bgColor;

    switch (_currentFace) {
      case 'happy':
        emoji = '😊';
        label = 'HAPPY';
        bgColor = const Color(0xFF4CAF50);
        break;
      case 'sleepy':
        emoji = '😴';
        label = 'SLEEPY';
        bgColor = const Color(0xFF2196F3);
        break;
      case 'tired':
        emoji = '😓';
        label = 'TIRED';
        bgColor = const Color(0xFFFF9800);
        break;
      case 'danger':
      default:
        emoji = '😱';
        label = 'DANGER';
        bgColor = const Color(0xFFF44336);
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 16),
          Text(
            'Driveboy is $label',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceButton(
      String emoji, String label, String face, Color color) {
    bool isActive = _currentFace == face;

    return ElevatedButton(
      onPressed: () => _changeFace(face),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? color : const Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isActive ? color : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _changeFace(String face) {
    setState(() => _currentFace = face);
    widget.esp32Service.setFace(face);
  }

  void _randomFace() {
    final faces = ['happy', 'sleepy', 'tired', 'danger'];
    final random = Random();
    final randomFace = faces[random.nextInt(faces.length)];
    _changeFace(randomFace);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🎲 Random face: ${randomFace.toUpperCase()}!')),
    );
  }

  void _startSinging() {
    widget.esp32Service.setHappy();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: const [
            Icon(Icons.music_note, color: Color(0xFFE91E63)),
            SizedBox(width: 8),
            Text('🎤 Sing Together', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Pick a song and sing along!',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '🎵 You Are My Sunshine',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              '🎵 Happy Together',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              '🎵 Don\'t Worry Be Happy',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '💡 Driveboy is listening and smiling!',
              style: TextStyle(
                  color: Color(0xFFE91E63),
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.esp32Service.setHappy();
              Navigator.pop(context);
            },
            child: const Text('Done Singing!'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Activities =====

  void _startBreathing() async {
    // Start breathing animation on ESP32
    try {
      await widget.esp32Service.startBreathing();
    } catch (e) {
      print('Failed to start breathing animation: $e');
      // Fallback to sleepy face
      widget.esp32Service.setSleepy();
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _BreathingDialog(
        esp32Service: widget.esp32Service,
        onComplete: () {
          widget.esp32Service.stopBreathing();
          widget.esp32Service.setHappy();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _startStretch() {
    widget.esp32Service.setExercise(); // 운동 표정 (땀 흘리는)

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _StretchDialog(
        esp32Service: widget.esp32Service,
        onComplete: () {
          widget.esp32Service.setHappy();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _startTapGame() {
    widget.esp32Service.setLaugh(); // 깔깔 웃는 표정

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _TapGameScreen(esp32Service: widget.esp32Service),
      ),
    );
  }

  void _startColorMatch() {
    widget.esp32Service.setFocus(); // 선글라스 집중

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _ColorMatchScreen(esp32Service: widget.esp32Service),
      ),
    );
  }

  void _startMemoryMatch() {
    widget.esp32Service.setFocus(); // 선글라스 집중

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _MemoryMatchScreen(esp32Service: widget.esp32Service),
      ),
    );
  }
}

// ===== Breathing Dialog =====
class _BreathingDialog extends StatefulWidget {
  final ESP32Service esp32Service;
  final VoidCallback onComplete;

  const _BreathingDialog({
    required this.esp32Service,
    required this.onComplete,
  });

  @override
  State<_BreathingDialog> createState() => _BreathingDialogState();
}

class _BreathingDialogState extends State<_BreathingDialog> {
  String _phase = 'Breathe In';
  int _count = 6; // Slower: 6 seconds instead of 4
  Timer? _timer;
  int _cycles = 0;

  @override
  void initState() {
    super.initState();
    _startBreathing();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBreathing() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _count--;

        // ESP32 표정 변경 (숨쉬는 애니메이션)
        if (_phase == 'Breathe In') {
          widget.esp32Service.setBreatheIn();
        } else {
          widget.esp32Service.setBreatheOut();
        }

        if (_count == 0) {
          if (_phase == 'Breathe In') {
            // Switch to exhale phase
            _phase = 'Breathe Out';
            _count = 6;
          } else {
            // Exhale completed - check if we should continue
            if (_cycles >= 2) {
              // Just completed 3rd cycle (cycles: 0, 1, 2 = 3 total)
              print('[Breathing] Completed 3 cycles! Closing dialog...');
              timer.cancel();
              // Close dialog immediately
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  print('[Breathing] Calling onComplete...');
                  widget.onComplete();
                }
              });
            } else {
              // Start next cycle
              _cycles++;
              print('[Breathing] Starting cycle ${_cycles + 1}');
              _phase = 'Breathe In';
              _count = 6;
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E3A8A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🫧 Breathe with Driveboy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              _phase,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF93C5FD),
              ),
            ),
            const SizedBox(height: 20),
            // Pulsing animation indicator
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.8, end: 1.2),
              builder: (context, value, child) => Transform.scale(
                scale: _phase == 'Breathe In' ? value : 2.2 - value,
                child: Text(
                  '$_count',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _phase == 'Breathe In'
                  ? 'Cycle ${_cycles + 1} / 3'
                  : 'Cycle ${_cycles + 1} / 3',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Driveboy is breathing with you',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Stretch Dialog with Checklist =====
class _StretchDialog extends StatefulWidget {
  final ESP32Service esp32Service;
  final VoidCallback onComplete;

  const _StretchDialog({
    required this.esp32Service,
    required this.onComplete,
  });

  @override
  State<_StretchDialog> createState() => _StretchDialogState();
}

class _StretchDialogState extends State<_StretchDialog> {
  final Map<String, bool> _stretches = {
    '🙆 Neck roll - 5x each direction': false,
    '🙋 Shoulder shrug - 10x up and down': false,
    '✋ Wrist rotation - 5x each direction': false,
    '🤸 Side stretch - Hold 10s each side': false,
    '🦵 Leg stretch - 10s each leg': false,
  };

  bool get _allChecked => !_stretches.values.contains(false);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(Icons.fitness_center, color: Color(0xFF81C784), size: 28),
                SizedBox(width: 12),
                Text(
                  'Stretch Break',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Complete all stretches:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            ..._stretches.keys.map(
              (stretch) => CheckboxListTile(
                title: Text(
                  stretch,
                  style: TextStyle(
                    color: _stretches[stretch]! ? Colors.white60 : Colors.white,
                    fontSize: 15,
                    decoration: _stretches[stretch]!
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                value: _stretches[stretch],
                onChanged: (value) {
                  setState(() {
                    _stretches[stretch] = value ?? false;
                  });
                },
                activeColor: const Color(0xFF81C784),
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _allChecked ? widget.onComplete : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _allChecked ? const Color(0xFF81C784) : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_allChecked
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked),
                    const SizedBox(width: 8),
                    Text(
                      _allChecked ? 'Done!' : 'Complete all stretches',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Tap Game =====
class _TapGameScreen extends StatefulWidget {
  final ESP32Service esp32Service;

  const _TapGameScreen({required this.esp32Service});

  @override
  State<_TapGameScreen> createState() => _TapGameScreenState();
}

class _TapGameScreenState extends State<_TapGameScreen> {
  int _taps = 0;
  int _timeLeft = 10;
  Timer? _timer;
  bool _gameStarted = false;

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _taps = 0;
      _timeLeft = 10;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft == 0) {
          timer.cancel();
          _showResult();
        }
      });
    });
  }

  void _tap() {
    if (_gameStarted && _timeLeft > 0) {
      setState(() => _taps++);
    }
  }

  void _showResult() {
    String message;
    if (_taps >= 50) {
      message = 'Amazing! 🎉';
      widget.esp32Service.setHappy();
    } else if (_taps >= 30) {
      message = 'Great! 👍';
      widget.esp32Service.setHappy();
    } else {
      message = 'Good try! 😊';
      widget.esp32Service.setSleepy();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(message, style: const TextStyle(color: Colors.white)),
        content: Text(
          'You tapped $_taps times!',
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Tap Game'),
      ),
      body: Center(
        child: _gameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_timeLeft',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFB74D),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _tap,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB74D),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB74D).withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'TAP!\n$_taps',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB74D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                ),
                child: const Text(
                  'Start Game',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }
}

// ===== Color Match Game =====
class _ColorMatchScreen extends StatefulWidget {
  final ESP32Service esp32Service;

  const _ColorMatchScreen({required this.esp32Service});

  @override
  State<_ColorMatchScreen> createState() => _ColorMatchScreenState();
}

class _ColorMatchScreenState extends State<_ColorMatchScreen> {
  final List<String> _colors = ['RED', 'BLUE', 'GREEN', 'YELLOW'];
  final List<Color> _colorValues = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  int _score = 0;
  String _currentText = '';
  Color _currentColor = Colors.white;
  int _correctAnswer = 0;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    final random = Random();
    int textIndex = random.nextInt(_colors.length);
    int colorIndex = random.nextInt(_colors.length);

    setState(() {
      _currentText = _colors[textIndex];
      _currentColor = _colorValues[colorIndex];
      _correctAnswer = colorIndex;
    });
  }

  void _answer(int index) {
    if (index == _correctAnswer) {
      setState(() => _score++);
      widget.esp32Service.setHappy();

      if (_score >= 10) {
        _showWin();
      } else {
        _nextRound();
      }
    } else {
      widget.esp32Service.setTired();
      _showLose();
    }
  }

  void _showWin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('You Win! 🎉', style: TextStyle(color: Colors.white)),
        content: Text(
          'Perfect score: $_score!',
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showLose() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Game Over', style: TextStyle(color: Colors.white)),
        content: Text(
          'Score: $_score',
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _score = 0);
              _nextRound();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text('Color Match - Score: $_score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'What COLOR is the text?',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              _currentText,
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: _currentColor,
              ),
            ),
            const SizedBox(height: 60),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(_colors.length, (index) {
                return ElevatedButton(
                  onPressed: () => _answer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorValues[index],
                    minimumSize: const Size(140, 60),
                  ),
                  child: Text(
                    _colors[index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Memory Match Game =====
class _MemoryMatchScreen extends StatefulWidget {
  final ESP32Service esp32Service;

  const _MemoryMatchScreen({required this.esp32Service});

  @override
  State<_MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<_MemoryMatchScreen> {
  // Card emojis (8 pairs = 16 cards)
  final List<String> _cardEmojis = [
    '🚗',
    '🚗',
    '⛽',
    '⛽',
    '🍔',
    '🍔',
    '☕',
    '☕',
    '🎵',
    '🎵',
    '⭐',
    '⭐',
    '🌙',
    '🌙',
    '💛',
    '💛',
  ];

  List<String> _cards = [];
  List<bool> _flipped = [];
  List<bool> _matched = [];

  int? _firstFlipped;
  int? _secondFlipped;
  int _moves = 0;
  int _matchedPairs = 0;
  bool _isChecking = false;
  bool _isPreview = true; // Show cards at start
  int _previewCountdown = 3;
  Timer? _previewTimer;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    super.dispose();
  }

  void _initGame() {
    setState(() {
      _cards = List.from(_cardEmojis)..shuffle();
      _flipped = List.filled(16, false);
      _matched = List.filled(16, false);
      _firstFlipped = null;
      _secondFlipped = null;
      _moves = 0;
      _matchedPairs = 0;
      _isChecking = false;
      _isPreview = true;
      _previewCountdown = 3;
    });

    // Start preview countdown
    _startPreview();
  }

  void _startPreview() {
    _previewTimer?.cancel();

    _previewTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _previewCountdown--;
        if (_previewCountdown <= 0) {
          _isPreview = false;
          timer.cancel();
        }
      });
    });
  }

  void _flipCard(int index) {
    // Don't flip if in preview, already flipped, matched, or checking
    if (_isPreview || _flipped[index] || _matched[index] || _isChecking) return;

    setState(() {
      _flipped[index] = true;

      if (_firstFlipped == null) {
        // First card flipped
        _firstFlipped = index;
      } else if (_secondFlipped == null) {
        // Second card flipped
        _secondFlipped = index;
        _moves++;
        _isChecking = true;

        // Check if they match
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;

          if (_cards[_firstFlipped!] == _cards[_secondFlipped!]) {
            // Match!
            setState(() {
              _matched[_firstFlipped!] = true;
              _matched[_secondFlipped!] = true;
              _matchedPairs++;
              _firstFlipped = null;
              _secondFlipped = null;
              _isChecking = false;

              // Check if all pairs matched
              if (_matchedPairs == 8) {
                widget.esp32Service.setHappy();
                _showWinDialog();
              }
            });
          } else {
            // No match - flip back
            setState(() {
              _flipped[_firstFlipped!] = false;
              _flipped[_secondFlipped!] = false;
              _firstFlipped = null;
              _secondFlipped = null;
              _isChecking = false;
            });
          }
        });
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: const [
            Icon(Icons.celebration, color: Color(0xFF26A69A), size: 32),
            SizedBox(width: 12),
            Text('Perfect Memory!', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You matched all pairs!',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Moves: $_moves',
              style: const TextStyle(
                color: Color(0xFF26A69A),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('🃏 Memory Match'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Moves: $_moves',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Preview countdown or matched pairs
              if (_isPreview)
                Column(
                  children: [
                    const Text(
                      'Memorize the cards!',
                      style: TextStyle(
                        color: Color(0xFF26A69A),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$_previewCountdown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'Matched: $_matchedPairs / 8 pairs',
                  style: const TextStyle(
                    color: Color(0xFF26A69A),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  // During preview, show all cards
                  bool shouldShowCard =
                      _isPreview || _flipped[index] || _matched[index];

                  return GestureDetector(
                    onTap: () => _flipCard(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: _matched[index]
                            ? const Color(0xFF26A69A).withOpacity(0.3)
                            : shouldShowCard
                                ? const Color(0xFF26A69A)
                                : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: shouldShowCard
                              ? const Color(0xFF26A69A)
                              : Colors.grey[800]!,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: _matched[index]
                            ? Text(
                                _cards[index],
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white30,
                                ),
                              )
                            : shouldShowCard
                                ? Text(
                                    _cards[index],
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: _isPreview
                                          ? Colors.white
                                          : Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.question_mark,
                                    color: Colors.white30,
                                    size: 32,
                                  ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _initGame,
                icon: const Icon(Icons.refresh),
                label: const Text('New Game'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
