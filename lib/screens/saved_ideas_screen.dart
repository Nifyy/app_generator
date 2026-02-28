import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SavedIdeasScreen extends StatefulWidget {
  final List<String> savedIdeas;

  const SavedIdeasScreen({super.key, required this.savedIdeas});

  @override
  State<SavedIdeasScreen> createState() => _SavedIdeasScreenState();
}

class _SavedIdeasScreenState extends State<SavedIdeasScreen> {
  late List<String> _ideas;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ideas = List.from(widget.savedIdeas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filtered => _ideas
      .where((idea) =>
          idea.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  void _removeIdea(int indexInFiltered) {
    final idea = _filtered[indexInFiltered];
    HapticFeedback.mediumImpact();
    setState(() {
      _ideas.remove(idea);
    });
  }

  void _copyIdea(String idea) {
    Clipboard.setData(ClipboardData(text: idea));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Copied to clipboard',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C2420),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1512),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MY COLLECTION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4ADE80),
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Saved Ideas',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_ideas.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF4ADE80).withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${_ideas.length}',
                        style: const TextStyle(
                          color: Color(0xFF4ADE80),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (_ideas.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF161E1A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.07),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search your ideas...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.25),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.white.withOpacity(0.3),
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white.withOpacity(0.3),
                                size: 18,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            Expanded(
              child: _ideas.isEmpty
                  ? _EmptyState()
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No ideas match "$_searchQuery"',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _IdeaCard(
                              idea: filtered[index],
                              index: index,
                              onDelete: () => _removeIdea(index),
                              onCopy: () => _copyIdea(filtered[index]),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdeaCard extends StatefulWidget {
  final String idea;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onCopy;

  const _IdeaCard({
    required this.idea,
    required this.index,
    required this.onDelete,
    required this.onCopy,
  });

  @override
  State<_IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<_IdeaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + widget.index * 50),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF141C18),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF4ADE80).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.index + 1}',
                      style: const TextStyle(
                        color: Color(0xFF4ADE80),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      widget.idea,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    _SmallIconBtn(
                      icon: Icons.copy_rounded,
                      onTap: widget.onCopy,
                      tooltip: 'Copy',
                    ),
                    const SizedBox(height: 6),
                    _SmallIconBtn(
                      icon: Icons.delete_outline_rounded,
                      onTap: widget.onDelete,
                      tooltip: 'Remove',
                      isDestructive: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallIconBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool isDestructive;

  const _SmallIconBtn({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.isDestructive = false,
  });

  @override
  State<_SmallIconBtn> createState() => _SmallIconBtnState();
}

class _SmallIconBtnState extends State<_SmallIconBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isDestructive
        ? const Color(0xFFFF6B6B)
        : Colors.white.withOpacity(0.45);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _pressed
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(widget.icon, color: color, size: 16),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.collections_bookmark_outlined,
                color: Colors.white.withOpacity(0.2),
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No saved ideas yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate ideas and save\nthe ones that inspire you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.25),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}