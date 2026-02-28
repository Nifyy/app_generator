import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/top_section.dart';
import '../utils/idea_list.dart';
import 'saved_ideas_screen.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String currentIdea = '';
  List<String> savedIdeas = [];
  bool _isAnimating = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void generateIdea() async {
    HapticFeedback.lightImpact();
    setState(() => _isAnimating = true);
    _fadeController.reset();

    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      currentIdea = ideas[Random().nextInt(ideas.length)];
      _isAnimating = false;
    });

    _fadeController.forward();
  }

  void saveIdea() {
    if (currentIdea.isNotEmpty && !savedIdeas.contains(currentIdea)) {
      HapticFeedback.mediumImpact();
      setState(() {
        savedIdeas.add(currentIdea);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ADE80).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF4ADE80),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Idea saved successfully',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 14,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1C2420),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (savedIdeas.contains(currentIdea)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Already in your collection',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          backgroundColor: const Color(0xFF1C2420),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1512),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopSection(),
                const SizedBox(height: 32),

                const Text(
                  'IDEA GENERATOR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4ADE80),
                    letterSpacing: 3.0,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Spark your next\nBig Project',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 28),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 140),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2820),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: currentIdea.isNotEmpty
                          ? const Color(0xFF4ADE80).withOpacity(0.25)
                          : Colors.white.withOpacity(0.07),
                      width: 1,
                    ),
                    boxShadow: currentIdea.isNotEmpty
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4ADE80).withOpacity(0.06),
                              blurRadius: 30,
                              spreadRadius: 0,
                            ),
                          ]
                        : [],
                  ),
                  child: currentIdea.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.tips_and_updates_outlined,
                                color: Colors.white.withOpacity(0.3),
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your idea appears here',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.35),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap Generate to get started',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                          ],
                        )
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4ADE80),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'NEW IDEA',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF4ADE80)
                                            .withOpacity(0.8),
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  currentIdea,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    height: 1.45,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 16),

                _PrimaryButton(
                  onTap: generateIdea,
                  isLoading: _isAnimating,
                  label: 'Generate Idea',
                  icon: Icons.auto_awesome_rounded,
                ),

                const SizedBox(height: 10),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: currentIdea.isNotEmpty
                      ? _SecondaryButton(
                          key: const ValueKey('save'),
                          onTap: saveIdea,
                          label: savedIdeas.contains(currentIdea)
                              ? 'Saved'
                              : 'Save This Idea',
                          icon: savedIdeas.contains(currentIdea)
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          isSaved: savedIdeas.contains(currentIdea),
                        )
                      : const SizedBox(key: ValueKey('empty'), height: 0),
                ),

                const SizedBox(height: 10),

                _CollectionButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SavedIdeasScreen(savedIdeas: savedIdeas),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 350),
                      ),
                    );
                  },
                  count: savedIdeas.length,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final bool isLoading;

  const _PrimaryButton({
    required this.onTap,
    required this.label,
    required this.icon,
    this.isLoading = false,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        transformAlignment: Alignment.center,
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _pressed
                ? [const Color(0xFF2E7D52), const Color(0xFF22633F)]
                : [const Color(0xFF36A867), const Color(0xFF2A8A52)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF36A867).withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final bool isSaved;

  const _SecondaryButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.isSaved,
  });

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        transformAlignment: Alignment.center,
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: widget.isSaved
              ? const Color(0xFF1A2820)
              : const Color(0xFF1E2B24),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isSaved
                ? const Color(0xFF4ADE80).withOpacity(0.4)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.isSaved
                  ? const Color(0xFF4ADE80)
                  : Colors.white.withOpacity(0.7),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.isSaved
                    ? const Color(0xFF4ADE80)
                    : Colors.white.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionButton extends StatefulWidget {
  final VoidCallback onTap;
  final int count;

  const _CollectionButton({required this.onTap, required this.count});

  @override
  State<_CollectionButton> createState() => _CollectionButtonState();
}

class _CollectionButtonState extends State<_CollectionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        transformAlignment: Alignment.center,
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF161E1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.collections_bookmark_outlined,
                  color: Colors.white.withOpacity(0.6),
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'My Collection',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              if (widget.count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF4ADE80).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${widget.count}',
                    style: const TextStyle(
                      color: Color(0xFF4ADE80),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Text(
                  'Empty',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.25),
                    fontSize: 13,
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}