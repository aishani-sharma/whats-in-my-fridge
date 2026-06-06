import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_keys.dart';

class RecipeService {
  
  // step 1 — search recipes by ingredients
  static Future<List<Map<String, dynamic>>> findByIngredients(
      List<String> ingredients) async {
    final ingredientStr = ingredients.join(',');
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/findByIngredients'
      '?ingredients=$ingredientStr'
      '&number=5'
      '&apiKey=$spoonacularApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }

  // step 2 — get full details for a specific recipe by id
  static Future<Map<String, dynamic>> getRecipeDetails(int id) async {
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/$id/information'
      '?apiKey=$spoonacularApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch recipe details');
    }
  }
}