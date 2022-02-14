import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.setState}) : super(key: key);

  final VoidCallback setState;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.9, 1.0, curve: Curves.easeIn),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.white),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                child: Text(
                  "Caricamento...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 150,
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Ci sta volendo\npiù tempo del previsto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.all(2)),
                  OutlinedButton(
                    onPressed: () {
                      setState;
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: CustomColors.darkGrey),
                      primary: CustomColors.white,
                    ),
                    child: const Text(
                      "Mostra dati salvati",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
