import 'package:flutter/material.dart';

class ClickerScreen extends StatefulWidget {
  const ClickerScreen({super.key});

  @override
  State<ClickerScreen> createState() => _ClickerScreenState();
}

class _ClickerScreenState extends State<ClickerScreen> {
  // Profile
  int _totalHealth = 10;
  int _currentHealth = 10;
  int _damage = 1;
  int _coin = 1;
  int _totalCoins = 0;

  // Level
  int _level = 1;

  final double _healthMultiplier = 2.5;
  final double _coinBonusMultiplier = 1.3;

  // Market
  int _damageLevel = 1;
  int _coinLevel = 1;

  final int _buyMoney = 20;
  final double _buyMoneyMultiplier = 1.5;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onClick() {
    if (_currentHealth - _damage <= 0) {
      return levelUp();
    }
    _currentHealth -= _damage;
    _totalCoins += _coin;
    setState(() {});
  }

  void levelUp() {
    _level += 1;
    final int newHealth = (_totalHealth * _healthMultiplier).ceil();
    _totalHealth = newHealth;
    _currentHealth = newHealth;
    _totalCoins += ((_level * _coinBonusMultiplier).floor() + _coin);
    setState(() {});
  }

  void _addDamage() {
    _damageLevel += 1;
    _damage += 1;
    setState(() {});
  }

  void _addCoin() {
    _coinLevel += 1;
    _coin += 1;
    setState(() {});
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: Text('Clicker - Level $_level'),
      ),
      body: SafeArea(child: _rootWidget()),
    );
  }

  Column _rootWidget() => Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _bounty(),
          ),
          Expanded(
            child: _clickableEntity(),
          ),
          Expanded(
            child: _market(),
          ),
        ],
      );

  List<Widget> _bounty() => [
        Text(_totalCoins.toString()),
        const SizedBox(
          width: 20,
        ),
        const Icon(Icons.lightbulb_circle_rounded),
        const SizedBox(
          width: 20,
        ),
      ];

  Column _clickableEntity() {
    final double currentHealthPercentage = (_currentHealth / _totalHealth);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: currentHealthPercentage,
                minHeight: 13,
                borderRadius: BorderRadius.circular(10),
                color:
                    currentHealthPercentage < 0.33 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(_currentHealth.toString()),
            ),
          ],
        ),
        SizedBox(
          height: 100,
          child: IconButton(
            icon: const Icon(
              Icons.people,
              size: 80,
              color: Colors.blue,
            ),
            onPressed: _onClick,
          ),
        ),
      ],
    );
  }

  Column _market() {
    final int damagePrice =
        ((_damageLevel * _buyMoneyMultiplier) + (_buyMoney * _damageLevel))
            .toInt();
    final int coinPrice = ((_coinLevel * _buyMoneyMultiplier) +
            (_buyMoney * _buyMoneyMultiplier * _coinLevel))
        .toInt();
    return Column(
      children: [
        ListTile(
          title: Text("Damage $_damageLevel"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.plus_one),
                onPressed: () {
                  if (_totalCoins >= damagePrice) {
                    _totalCoins -= damagePrice;
                    _addDamage();
                  }
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Text(damagePrice.toString()),
            ],
          ),
        ),
        ListTile(
          title: Text("Coin $_coinLevel"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.plus_one),
                onPressed: () {
                  if (_totalCoins >= coinPrice) {
                    _totalCoins -= coinPrice;
                    _addCoin();
                  }
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Text(coinPrice.toString()),
            ],
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        Text('Current Damage $_damage'),
        Text('Current ClickValue $_coin')
      ],
    );
  }
}
