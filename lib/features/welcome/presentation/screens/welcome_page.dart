import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/welcome_bloc.dart';
import '../blocs/welcome_event.dart';
import '../blocs/welcome_state.dart';
import '../../../home/presentation/screens/home.dart'; // Update path accordingly

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WelcomeBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  width: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 120, color: Colors.red);
                  },
                ),
                const SizedBox(height: 20),

                // Welcome Message
                const Text(
                  'Welcome to Faraz',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Subtitle
                const Text(
                  'Please select your country.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // BlocBuilder to React to State Changes
                BlocConsumer<WelcomeBloc, WelcomeState>(
                    listener: (context, state) {
                      if (state is CountrySelectedState) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(country: state.country),
                          ),
                              (route) => false, // Clears all previous routes
                        );
                      }
                    },
                  builder: (context, state) {
                    if (state is CountrySelectionInProgress) {
                      return const CircularProgressIndicator();
                    }

                    return Column(
                      children: [
                        CountryButton(
                          country: 'Bangladesh',
                          onPressed: () {
                            context
                                .read<WelcomeBloc>()
                                .add(const CountrySelectedEvent('Bangladesh'));
                          },
                        ),
                        CountryButton(
                          country: 'Sri Lanka',
                          onPressed: () {
                            context
                                .read<WelcomeBloc>()
                                .add(const CountrySelectedEvent('Sri Lanka'));
                          },
                        ),
                        CountryButton(
                          country: 'Nepal',
                          onPressed: () {
                            context
                                .read<WelcomeBloc>()
                                .add(const CountrySelectedEvent('Nepal'));
                          },
                        ),
                        CountryButton(
                          country: 'Pakistan',
                          onPressed: () {
                            context
                                .read<WelcomeBloc>()
                                .add(const CountrySelectedEvent('Pakistan'));
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CountryButton extends StatelessWidget {
  final String country;
  final VoidCallback onPressed;

  const CountryButton({
    Key? key,
    required this.country,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            country,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
