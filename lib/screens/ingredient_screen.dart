import 'package:flutter/material.dart';
import 'recipe_results_screen.dart';

class IngredientScreen extends StatefulWidget {
  const IngredientScreen({super.key});

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  final List<Map<String, String>> allIngredients = [
    {'image': 'Apple.png', 'name': 'APPLE'},
    {'image': 'Bread.png', 'name': 'BREAD'},
    {'image': 'Carrot.png', 'name': 'CARROT'},
    {'image': 'Cheese.png', 'name': 'CHEESE'},
    {'image': 'Corn.png', 'name': 'CORN'},
    {'image': 'Egg.png', 'name': 'EGG'},
    {'image': 'Fish.png', 'name': 'FISH'},
    {'image': 'Garlic.png', 'name': 'GARLIC'},
    {'image': 'mushroom.png', 'name': 'MUSHROOM'},
    {'image': 'RawChicken.png', 'name': 'CHICKEN'},
    {'image': 'RawMeat.png', 'name': 'MEAT'},
    {'image': 'Tomato.png', 'name': 'TOMATO'},
    {'image': 'WheatBundle.png', 'name': 'WHEAT'},
    {'image': 'Melon.png', 'name': 'MELON'},
    {'image': '13_bacon.png', 'name': 'BACON'},
    {'image': '88_salmon.png', 'name': 'SALMON'},
  ];

  List<Map<String, String>> fridgeItems = [];
  String searchQuery = '';

  List<Map<String, String>> get filteredIngredients {
    if (searchQuery.isEmpty) return allIngredients;
    return allIngredients
        .where((i) => i['name']!.contains(searchQuery.toUpperCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF2C4CE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── search bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F3),
                  border: Border.all(
                      color: const Color(0xFF5C3317), width: 2),
                ),
                child: TextField(
                  onChanged: (val) =>
                      setState(() => searchQuery = val),
                  style: const TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 8,
                    color: Color(0xFF3D1F0D),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'SEARCH...',
                    hintStyle: TextStyle(
                      fontFamily: 'PixelFont',
                      fontSize: 8,
                      color: Color(0xFF5C3317),
                    ),
                    prefixIcon: Icon(Icons.search,
                        color: Color(0xFF5C3317), size: 16),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10),
                    isDense: true,
                  ),
                ),
              ),
            ),

            // ── ingredient strip (horizontal, scrolls left-right) ──
            Container(
              height: 80,
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F3),
                border: Border.all(
                    color: const Color(0xFF5C3317), width: 2),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 6),
                itemCount: filteredIngredients.length,
                itemBuilder: (context, index) {
                  final ingredient = filteredIngredients[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4),
                    child: Draggable<Map<String, String>>(
                      data: ingredient,
                      feedback: _buildDragFeedback(ingredient),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: _buildIngredientTile(ingredient),
                      ),
                      child: _buildIngredientTile(ingredient),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // ── my fridge label ──
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12),
              child: const Text(
                'MY FRIDGE',
                style: TextStyle(
                  fontFamily: 'PixelFont',
                  fontSize: 10,
                  color: Color(0xFF3D1F0D),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── fridge with drag target ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DragTarget<Map<String, String>>(
                  onAcceptWithDetails: (details) {
                    final item = details.data;
                    if (!fridgeItems.contains(item)) {
                      setState(() => fridgeItems.add(item));
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isHovering = candidateData.isNotEmpty;
                    return Stack(
                      children: [

                        // fridge image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/Fridge.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.topCenter,
                            filterQuality: FilterQuality.none,
                          ),
                        ),

                        // hover glow
                        if (isHovering)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: screenWidth * 0.48,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8748A)
                                    .withValues(alpha: 0.15),
                                border: Border.all(
                                  color: const Color(0xFFE8748A),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                        // empty hint
                        if (fridgeItems.isEmpty && !isHovering)
                          Positioned(
                            left: 0,
                            width: screenWidth * 0.48,
                            top: screenHeight * 0.25,
                            height: screenHeight * 0.32,
                            child: const Center(
                              child: Text(
                                'DRAG\nHERE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'PixelFont',
                                  fontSize: 7,
                                  color: Color(0xFF5C3317),
                                ),
                              ),
                            ),
                          ),

                        // floating ingredients on shelves
                        if (fridgeItems.isNotEmpty)
                          Positioned(
                            left: 12,
                            width: screenWidth * 0.45,
                            top: screenHeight * 0.25,
                            height: screenHeight * 0.32,
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: fridgeItems.map((item) {
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => fridgeItems.remove(item)),
                                  child: Image.asset(
                                    'assets/images/${item['image']}',
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.none,
                                    errorBuilder: (c, e, s) =>
                                        const SizedBox(
                                            width: 28, height: 28),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                      ],
                    );
                  },
                ),
              ),
            ),

            // ── find recipes button ──
            Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: fridgeItems.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeResultsScreen(
                              ingredients: fridgeItems
                                  .map((item) => item['name']!.toLowerCase())
                                  .toList(),
                            ),
                          ),
                        );
                      },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: fridgeItems.isEmpty
                        ? const Color(0xFFD4A0A8)
                        : const Color(0xFFE8748A),
                    border: Border.all(
                        color: const Color(0xFF5C3317), width: 3),
                  ),
                  child: const Center(
                    child: Text(
                      'FIND RECIPES',
                      style: TextStyle(
                        fontFamily: 'PixelFont',
                        fontSize: 12,
                        color: Color(0xFFFFF0F3),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildIngredientTile(Map<String, String> ingredient) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/${ingredient['image']}',
          width: 36,
          height: 36,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
          errorBuilder: (c, e, s) =>
              const SizedBox(width: 36, height: 36),
        ),
        const SizedBox(height: 2),
        Text(
          ingredient['name']!,
          style: const TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 5,
            color: Color(0xFF3D1F0D),
          ),
        ),
      ],
    );
  }

  Widget _buildDragFeedback(Map<String, String> ingredient) {
    return Material(
      color: Colors.transparent,
      child: Image.asset(
        'assets/images/${ingredient['image']}',
        width: 44,
        height: 44,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
      ),
    );
  }
}