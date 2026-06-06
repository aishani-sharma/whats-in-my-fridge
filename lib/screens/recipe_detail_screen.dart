import 'package:flutter/material.dart';
import '../services/recipe_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  final String recipeTitle;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    required this.recipeTitle,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map<String, dynamic>? recipeDetail;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final result = await RecipeService.getRecipeDetails(widget.recipeId);
      setState(() {
        recipeDetail = result;
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
                  Expanded(
                    child: Text(
                      widget.recipeTitle.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'PixelFont',
                        fontSize: 10,
                        color: Color(0xFF3D1F0D),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // ── loading / error / content ──
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
                            'LOADING RECIPE...',
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
                      : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final cookTime = recipeDetail!['readyInMinutes'] ?? '?';
    final servings = recipeDetail!['servings'] ?? '?';
    final ingredients = recipeDetail!['extendedIngredients'] as List? ?? [];
    final steps = (recipeDetail!['analyzedInstructions'] as List?)
            ?.firstOrNull?['steps'] as List? ??
        [];

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [

        // ── cook time + servings ──
        Row(
          children: [
            _buildInfoChip('⏱ $cookTime MINS'),
            const SizedBox(width: 8),
            _buildInfoChip('🍽 $servings SERVINGS'),
          ],
        ),

        const SizedBox(height: 16),

        // ── ingredients ──
        _buildSectionTitle('INGREDIENTS'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F3),
            border: Border.all(color: const Color(0xFF5C3317), width: 3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredients.map<Widget>((ing) {
              final name = ing['original'] ?? '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '▸ ',
                      style: TextStyle(
                        fontFamily: 'PixelFont',
                        fontSize: 7,
                        color: Color(0xFFE8748A),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        name.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'PixelFont',
                          fontSize: 7,
                          color: Color(0xFF3D1F0D),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // ── steps ──
        _buildSectionTitle('INSTRUCTIONS'),
        const SizedBox(height: 8),

        if (steps.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F3),
              border:
                  Border.all(color: const Color(0xFF5C3317), width: 3),
            ),
            child: const Text(
              'NO INSTRUCTIONS AVAILABLE.',
              style: TextStyle(
                fontFamily: 'PixelFont',
                fontSize: 7,
                color: Color(0xFF3D1F0D),
              ),
            ),
          )
        else
          ...steps.map<Widget>((step) {
            final number = step['number'] ?? '';
            final instruction = step['step'] ?? '';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F3),
                border:
                    Border.all(color: const Color(0xFF5C3317), width: 3),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8748A),
                      border: Border.all(
                          color: const Color(0xFF5C3317), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$number',
                        style: const TextStyle(
                          fontFamily: 'PixelFont',
                          fontSize: 7,
                          color: Color(0xFFFFF0F3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      instruction.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'PixelFont',
                        fontSize: 7,
                        color: Color(0xFF3D1F0D),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'PixelFont',
        fontSize: 11,
        color: Color(0xFF3D1F0D),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F3),
        border: Border.all(color: const Color(0xFF5C3317), width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'PixelFont',
          fontSize: 7,
          color: Color(0xFF3D1F0D),
        ),
      ),
    );
  }
}