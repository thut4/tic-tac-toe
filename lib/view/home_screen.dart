import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constant/app_color.dart';
import 'package:tic_tac_toe/controller/game_controller.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameController>(context);

    return Scaffold(
        appBar: AppBar(
          title: TextWidget(
            textName: 'Tic-Tac-Toe',
            fontSize: 28,
            color: AppColor.blueColor,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!gameProvider.isOver)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: MainButton(
                      onTap: () => gameProvider.setPlayMode(false),
                      color: gameProvider.isAi
                          ? AppColor.blueColor
                          : AppColor.greenColor,
                      name: '2 Players',
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 150,
                    child: MainButton(
                      onTap: () => gameProvider.setPlayMode(true),
                      color: gameProvider.isAi
                          ? AppColor.greenColor
                          : AppColor.redColor,
                      name: 'Play with AI',
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            _buildGameBoard(gameProvider),
            const SizedBox(height: 10),
            if (gameProvider.isOver)
              TextWidget(
                textName: gameProvider.winner != ''
                    ? 'Winner: ${gameProvider.winner}'
                    : 'It\'s a Draw!',
                fontSize: 20,
                color: AppColor.blackColor,
                fontWeight: FontWeight.w500,
              ),
            const SizedBox(height: 20),
            SizedBox(
                height: 50,
                width: 175,
                child: MainButton(
                  onTap: () => gameProvider.resetGame(),
                  color: AppColor.dimGrey,
                  name: 'Restart Game',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ));
  }

  Widget _buildGameBoard(GameController gameController) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: gameController.board.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _controller.forward(from: 0.0);
            gameController.makeMove(index);
          },
          child: AnimatedContainer(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColor.grey.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: const Offset(0, 0.2),
                    blurStyle: BlurStyle.normal,
                  )
                ],
                border: Border.all(color: AppColor.lightMode),
                color: AppColor.grey,
                borderRadius: BorderRadius.circular(15)),
            duration: const Duration(milliseconds: 300),
            child: Center(
                child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                    angle: _animation.value * 2.0 * 3.14159, child: child);
              },
              child: TextWidget(
                textName: gameController.board[index],
                fontSize: 40,
                color: gameController.board[index] == 'X'
                    ? AppColor.blueColor
                    : gameController.board[index] == 'O'
                        ? AppColor.redColor
                        : AppColor.blackColor,
              ),
            )),
          ),
        );
      },
    );
  }
}

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.name,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
  });

  final Color color;
  final VoidCallback onTap;
  final String name;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onTap,
      child: TextWidget(
        textName: name,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
