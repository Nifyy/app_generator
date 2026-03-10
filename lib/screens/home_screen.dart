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
      setState(() => savedIdeas.add(currentIdea));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.check_rounded,
                    color: Color(0xFFF59E0B), size: 16),
              ),
              const SizedBox(width: 12),
              const Text('Idea saved to collection',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          backgroundColor: const Color(0xFF1A1A1A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (savedIdeas.contains(currentIdea)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Already in your collection',
              style: TextStyle(fontSize: 14, color: Colors.white60)),
          backgroundColor: const Color(0xFF1A1A1A),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopSection(),
                const SizedBox(height: 36),

                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'GENERATOR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.4),
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Spark Your\n',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -1.0,
                        ),
                      ),
                      TextSpan(
                        text: 'Next Big Idea',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF59E0B),
                          height: 1.1,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 150),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: currentIdea.isNotEmpty
                          ? const Color(0xFFF59E0B).withOpacity(0.3)
                          : Colors.white.withOpacity(0.06),
                      width: 1,
                    ),
                    boxShadow: currentIdea.isNotEmpty
                        ? [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withOpacity(0.05),
                              blurRadius: 30,
                            )
                          ]
                        : [],
                  ),
                  child: currentIdea.isEmpty
                      ? _EmptyIdeaCard()
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _FilledIdeaCard(idea: currentIdea),
                          ),
                        ),
                ),

                const SizedBox(height: 16),

                _GenerateButton(onTap: generateIdea, isLoading: _isAnimating),

                const SizedBox(height: 12),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: currentIdea.isNotEmpty
                      ? _SaveButton(
                          key: const ValueKey('save'),
                          onTap: saveIdea,
                          isSaved: savedIdeas.contains(currentIdea),
                        )
                      : const SizedBox(key: ValueKey('empty'), height: 0),
                ),

                const SizedBox(height: 12),

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

class _EmptyIdeaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              3,
              (i) => Container(
                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                width: i == 0 ? 40 : (i == 1 ? 60 : 30),
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.bolt_rounded,
                  color: Colors.white.withOpacity(0.15), size: 18),
              const SizedBox(width: 8),
              Text(
                'Hit Generate to get started',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.2),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilledIdeaCard extends StatelessWidget {
  final String idea;
  const _FilledIdeaCard({required this.idea});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(0.25)),
            ),
            child: const Text(
              'NEW IDEA',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Color(0xFFF59E0B),
                letterSpacing: 2.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            idea,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.4,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _GenerateButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;
  const _GenerateButton({required this.onTap, this.isLoading = false});

  @override
  State<_GenerateButton> createState() => _GenerateButtonState();
}

class _GenerateButtonState extends State<_GenerateButton> {
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
        height: 60,
        decoration: BoxDecoration(
          color: _pressed ? const Color(0xFFD97706) : const Color(0xFFF59E0B),
          borderRadius: BorderRadius.circular(18),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome_rounded,
                color: Color(0xFF0A0A0A), size: 20),
            const SizedBox(width: 10),
            const Text(
              'Generate Idea',
              style: TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSaved;
  const _SaveButton({super.key, required this.onTap, required this.isSaved});

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
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
        height: 54,
        decoration: BoxDecoration(
          color: widget.isSaved
              ? const Color(0xFFF59E0B).withOpacity(0.08)
              : const Color(0xFF161616),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: widget.isSaved
                ? const Color(0xFFF59E0B).withOpacity(0.35)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.isSaved
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: widget.isSaved
                  ? const Color(0xFFF59E0B)
                  : Colors.white.withOpacity(0.5),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              widget.isSaved ? 'Saved' : 'Save This Idea',
              style: TextStyle(
                color: widget.isSaved
                    ? const Color(0xFFF59E0B)
                    : Colors.white.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w600,
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
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.collections_bookmark_outlined,
                    color: Colors.white.withOpacity(0.5), size: 18),
              ),
              const SizedBox(width: 14),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Collection',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  Text(
                    widget.count > 0
                        ? '${widget.count} idea${widget.count == 1 ? '' : 's'} saved'
                        : 'No ideas saved yet',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.25),
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Spacer(),
              if (widget.count > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${widget.count}',
                      style: const TextStyle(
                          color: Color(0xFF0A0A0A),
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.2), size: 14),
            ],
          ),
        ),
      ),
    );
  }
}