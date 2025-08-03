import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/noise_texture.png'), // Assuming a noise texture image
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold background transparent
        appBar: AppBar(
          title: Text(
            'Gradium',
            style: GoogleFonts.exo2(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildWelcomeMessage(context),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Use card color for background
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school, // Example icon
            size: 48.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Welcome to Gradium!',
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(
              fontSize: 28.0,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary, // Use primary color
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Your academic journey starts here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}