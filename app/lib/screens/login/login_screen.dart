import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/services/pocketbase_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await PocketBaseService.pb.collection('users').authWithPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email ou mot de passe incorrect"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900, // Avenir-Black
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 50),

                // Champ Email
                _buildTextField(
                  controller: _emailController,
                  hintText: "Adresse email",
                  icon: Icons.email,
                  isObscure: false,
                ),
                const SizedBox(height: 16),

                // Champ Mot de passe
                _buildTextField(
                  controller: _passwordController,
                  hintText: "Mot de passe",
                  icon: Icons.lock,
                  isObscure: true,
                ),
                const SizedBox(height: 40),

                // Bouton Créer un compte
                _buildYellowButton(
                  text: "Créer un compte",
                  onPressed: () => context.push('/register'),
                ),
                const SizedBox(height: 16),

                // Bouton Se connecter
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.yellow)
                    : _buildYellowButton(
                        text: "Se connecter",
                        onPressed: _login,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Composants réutilisables pour le Pixel Perfect ---

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon, required bool isObscure}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.grey2, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.blue, size: 20),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.grey2, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.blue, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildYellowButton({required String text, required VoidCallback onPressed}) {
    return FractionallySizedBox(
      widthFactor: 0.7, // Le bouton prend 70% de la largeur comme sur la maquette
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.blue,
          elevation: 0, // Pas d'ombre sur la maquette
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Forme de pilule
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}