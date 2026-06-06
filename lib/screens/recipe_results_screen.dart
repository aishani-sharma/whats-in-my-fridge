import 'package:flutter/material.dart';
import '../services/recipe_service.dart';

class RecipeResultsScreen extends StatefulWidget {
  final List<String> ingredients;

  const RecipeResultsScreen({super.key, required this.ingredients});

  @override
  State<RecipeResultsScreen> createState() => _RecipeResultsScreenState();
}

class _RecipeResultsScreenState extends State<RecipeResultsScreen> {
  List<Map<String, dynamic>> recipes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      final results = await RecipeService.findByIngredients(widget.ingredients);
      setState(() {
        recipes = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'FAILED TO LOAD.\nCHECK CONNECTION.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2C4CE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F3),
                        border: Border.all(
                            color: const Color(0xFF5C3317), width: 2),
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Color(0xFF5C3317), size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'RECIPES',
                    style: TextStyle(
                      fontFamily: 'PixelFont',
                      fontSize: 16,
                      color: Color(0xFF3D1F0D),
                    ),
                  ),
                ],
              ),
            ),

            // ── ingredients used ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.ingredients.map((ing) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8748A),
                      border: Border.all(
                          color: const Color(0xFF5C3317), width: 2),
                    ),
                    child: Text(
                      ing.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'PixelFont',
                        fontSize: 6,
                        color: Color(0xFFFFF0F3),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // ── loading / error / results ──
            Expanded(
              child: isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFF5C3317),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'COOKING UP\nRESULTS...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PixelFont',
                              fontSize: 10,
                              color: Color(0xFF3D1F0D),
                            ),
                          ),
                        ],
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'PixelFont',
                              fontSize: 10,
                              color: Color(0xFF3D1F0D),
                            ),
                          ),
                        )
                      : recipes.isEmpty
                          ? const Center(
                              child: Text(
                                'NO RECIPES FOUND.\nTRY MORE INGREDIENTS!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'PixelFont',
                                  fontSize: 10,
                                  color: Color(0xFF3D1F0D),
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = recipes[index];
                                return _buildRecipeCard(recipe);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    final title = recipe['title'] ?? 'UNKNOWN';
    final usedCount = recipe['usedIngredientCount'] ?? 0;
    final missedCount = recipe['missedIngredientCount'] ?? 0;

    return GestureDetector(
      onTap: () {
        // navigate to recipe detail screen later
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F3),
          border: Border.all(color: const Color(0xFF5C3317), width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // recipe title
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'PixelFont',
                fontSize: 9,
                color: Color(0xFF3D1F0D),
              ),
            ),

            const SizedBox(height: 8),

            // used vs missing ingredients
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C3317),
                    border: Border.all(
                        color: const Color(0xFF3D1F0D), width: 1),
                  ),
                  child: Text(
                    '✓ $usedCount HAVE',
                    style: const TextStyle(
                      fontFamily: 'PixelFont',
                      fontSize: 6,
                      color: Color(0xFFFFF0F3),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2C4CE),
                    border: Border.all(
                        color: const Color(0xFF5C3317), width: 1),
                  ),
                  child: Text(
                    '✗ $missedCount MISSING',
                    style: const TextStyle(
                      fontFamily: 'PixelFont',
                      fontSize: 6,
                      color: Color(0xFF3D1F0D),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}