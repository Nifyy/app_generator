import 'package:flutter/material.dart';

class SavedIdeasScreen extends StatelessWidget {
  final List<String> savedIdeas;

  const SavedIdeasScreen({super.key, required this.savedIdeas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B6B5E),
      appBar: AppBar(
        title: const Text('Saved Ideas'),
        backgroundColor: const Color(0xFF2D3A31),
        foregroundColor: Colors.white,
      ),
      body: savedIdeas.isEmpty
          ? const Center(
              child: Text(
                'No saved ideas yet!\nGenerate and save some ideas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: savedIdeas.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3A31),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          savedIdeas[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}