import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GachaRPGApp());
}

class GachaRPGApp extends StatelessWidget {
  const GachaRPGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shadow Legends Ultra',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0814),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF16122C),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

enum Rarity { SSR, SR, R }

class Equipment {
  final String id;
  final String name;
  final String type;
  final int bonusAtk;
  final int bonusHp;
  final Rarity rarity;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.bonusAtk,
    required this.bonusHp,
    required this.rarity,
  });

  Color get rarityColor {
    switch (rarity) {
      case Rarity.SSR: return const Color(0xFFFFD700);
      case Rarity.SR: return const Color(0xFFA020F0);
      case Rarity.R: return const Color(0xFF1E90FF);
    }
  }
}

class HeroItem {
  final String id;
  final String name;
  final String title;
  final Rarity rarity;
  final Color themeColor;
  int level;
  int baseHp;
  int baseAtk;
  int baseDef;
  Equipment? equippedWeapon;
  Equipment? equippedArmor;

  HeroItem({
    required this.id,
    required this.name,
    required this.title,
    required this.rarity,
    required this.themeColor,
    this.level = 1,
    required this.baseHp,
    required this.baseAtk,
    required this.baseDef,
    this.equippedWeapon,
    this.equippedArmor,
  });

  int get currentHp => baseHp + ((level - 1) * 150) + (equippedArmor?.bonusHp ?? 0) + (equippedWeapon?.bonusHp ?? 0);
  int get currentAtk => baseAtk + ((level - 1) * 35) + (equippedWeapon?.bonusAtk ?? 0) + (equippedArmor?.bonusAtk ?? 0);

  String get rarityStr => rarity.name;

  Color get rarityColor {
    switch (rarity) {
      case Rarity.SSR: return const Color(0xFFFFD700);
      case Rarity.SR: return const Color(0xFFA020F0);
      case Rarity.R: return const Color(0xFF1E90FF);
    }
  }

  HeroItem copy() {
    return HeroItem(
      id: id,
      name: name,
      title: title,
      rarity: rarity,
      themeColor: themeColor,
      level: level,
      baseHp: baseHp,
      baseAtk: baseAtk,
      baseDef: baseDef,
    );
  }
}

class BossEnemy {
  final String name;
  final int hp;
  final int atk;
  final int gemReward;
  final int goldReward;
  final Color color;

  BossEnemy({
    required this.name,
    required this.hp,
    required this.atk,
    required this.gemReward,
    required this.goldReward,
    required this.color,
  });
}

final List<HeroItem> allHeroesPool = [
  HeroItem(id: 'ssr_1', name: 'Aurelia', title: 'Sun Empress', rarity: Rarity.SSR, themeColor: const Color(0xFFFFD700), baseHp: 1200, baseAtk: 280, baseDef: 150),
  HeroItem(id: 'ssr_2', name: 'Ignis', title: 'Inferno Dragon', rarity: Rarity.SSR, themeColor: const Color(0xFFFF4500), baseHp: 1100, baseAtk: 320, baseDef: 120),
  HeroItem(id: 'ssr_3', name: 'Void', title: 'Shadow Emperor', rarity: Rarity.SSR, themeColor: const Color(0xFF8A2BE2), baseHp: 1050, baseAtk: 350, baseDef: 110),
  HeroItem(id: 'sr_1', name: 'Valerie', title: 'Frost Valkyrie', rarity: Rarity.SR, themeColor: const Color(0xFF00FFFF), baseHp: 850, baseAtk: 190, baseDef: 100),
  HeroItem(id: 'sr_2', name: 'Kael', title: 'Thunder Warden', rarity: Rarity.SR, themeColor: const Color(0xFFFFE4B5), baseHp: 900, baseAtk: 180, baseDef: 120),
  HeroItem(id: 'sr_3', name: 'Sylvia', title: 'Wind Ranger', rarity: Rarity.SR, themeColor: const Color(0xFF00FF7F), baseHp: 750, baseAtk: 210, baseDef: 80),
  HeroItem(id: 'r_1', name: 'Iron Guard', title: 'Novice Defender', rarity: Rarity.R, themeColor: const Color(0xFF708090), baseHp: 600, baseAtk: 100, baseDef: 90),
  HeroItem(id: 'r_2', name: 'Fire Apprentice', title: 'Mage Initiate', rarity: Rarity.R, themeColor: const Color(0xFFCD5C5C), baseHp: 500, baseAtk: 140, baseDef: 50),
  HeroItem(id: 'r_3', name: 'Scout Raven', title: 'Shadow Runner', rarity: Rarity.R, themeColor: const Color(0xFF4682B4), baseHp: 550, baseAtk: 120, baseDef: 60),
];

final List<Equipment> equipmentPool = [
  Equipment(id: 'eq_1', name: 'Excalibur', type: 'Weapon', bonusAtk: 200, bonusHp: 100, rarity: Rarity.SSR),
  Equipment(id: 'eq_2', name: 'Aegis Shield', type: 'Armor', bonusAtk: 30, bonusHp: 600, rarity: Rarity.SSR),
  Equipment(id: 'eq_3', name: 'Shadow Blade', type: 'Weapon', bonusAtk: 110, bonusHp: 0, rarity: Rarity.SR),
  Equipment(id: 'eq_4', name: 'Dragon Scale Armor', type: 'Armor', bonusAtk: 20, bonusHp: 350, rarity: Rarity.SR),
  Equipment(id: 'eq_5', name: 'Iron Sword', type: 'Weapon', bonusAtk: 50, bonusHp: 0, rarity: Rarity.R),
  Equipment(id: 'eq_6', name: 'Leather Vest', type: 'Armor', bonusAtk: 0, bonusHp: 150, rarity: Rarity.R),
];

final List<BossEnemy> bossList = [
  BossEnemy(name: 'Goblin King (Easy)', hp: 800, atk: 50, gemReward: 100, goldReward: 300, color: Colors.greenAccent),
  BossEnemy(name: 'Demon Lord (Medium)', hp: 1800, atk: 90, gemReward: 250, goldReward: 700, color: Colors.orangeAccent),
  BossEnemy(name: 'Abyssal Dragon (Hard)', hp: 3500, atk: 150, gemReward: 500, goldReward: 1500, color: Colors.purpleAccent),
];

// STATE GLOBAL GAME
int playerGems = 2000;
int playerGold = 10000;
int pityCounter = 0;
int hpPotions = 3;

// QUEST TRACKING
bool qSummonDone = false;
bool qBattleDone = false;
bool qShopDone = false;

List<HeroItem> playerInventory = [allHeroesPool[6].copy()];
List<Equipment> equipmentInventory = [equipmentPool[4], equipmentPool[5]];

// HELPER SAVE & LOAD
Future<void> saveGameData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('gems', playerGems);
  await prefs.setInt('gold', playerGold);
  await prefs.setInt('pity', pityCounter);
  await prefs.setInt('potions', hpPotions);
  await prefs.setBool('q_summon', qSummonDone);
  await prefs.setBool('q_battle', qBattleDone);
  await prefs.setBool('q_shop', qShopDone);
}

Future<void> loadGameData() async {
  final prefs = await SharedPreferences.getInstance();
  playerGems = prefs.getInt('gems') ?? 2000;
  playerGold = prefs.getInt('gold') ?? 10000;
  pityCounter = prefs.getInt('pity') ?? 0;
  hpPotions = prefs.getInt('potions') ?? 3;
  qSummonDone = prefs.getBool('q_summon') ?? false;
  qBattleDone = prefs.getBool('q_battle') ?? false;
  qShopDone = prefs.getBool('q_shop') ?? false;
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadGameData().then((_) => setState(() {}));
  }

  void _updateState() {
    saveGameData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      SummonScreen(onStateChanged: _updateState),
      CollectionScreen(onStateChanged: _updateState),
      BattleScreen(onStateChanged: _updateState),
      ShopScreen(onStateChanged: _updateState),
      QuestScreen(onStateChanged: _updateState),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF140F2A),
        elevation: 6,
        title: const Text('SHADOW LEGENDS', style: TextStyle(fontWeight: FontWeight.black, letterSpacing: 1.5, color: Colors.white)),
        actions: [
          _buildResourceChip(Icons.diamond, '$playerGems', const Color(0xFF00E5FF)),
          const SizedBox(width: 6),
          _buildResourceChip(Icons.monetization_on, '$playerGold', const Color(0xFFFFD700)),
          const SizedBox(width: 6),
          _buildResourceChip(Icons.science, '$hpPotions', const Color(0xFF00FF7F)),
          const SizedBox(width: 12),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF140F2A),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white38,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Summon'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Heroes'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Battle'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Quests'),
        ],
      ),
    );
  }

  Widget _buildResourceChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 3),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
        ],
      ),
    );
  }
}

class SummonScreen extends StatefulWidget {
  final VoidCallback onStateChanged;
  const SummonScreen({super.key, required this.onStateChanged});

  @override
  State<SummonScreen> createState() => _SummonScreenState();
}

class _SummonScreenState extends State<SummonScreen> {
  final Random _random = Random();

  HeroItem _rollHero() {
    pityCounter++;
    int roll = _random.nextInt(100);

    if (pityCounter >= 10) {
      pityCounter = 0;
      var ssrList = allHeroesPool.where((h) => h.rarity == Rarity.SSR).toList();
      return ssrList[_random.nextInt(ssrList.length)].copy();
    }

    if (roll < 5) {
      pityCounter = 0;
      var ssrList = allHeroesPool.where((h) => h.rarity == Rarity.SSR).toList();
      return ssrList[_random.nextInt(ssrList.length)].copy();
    } else if (roll < 30) {
      var srList = allHeroesPool.where((h) => h.rarity == Rarity.SR).toList();
      return srList[_random.nextInt(srList.length)].copy();
    } else {
      var rList = allHeroesPool.where((h) => h.rarity == Rarity.R).toList();
      return rList[_random.nextInt(rList.length)].copy();
    }
  }

  void _executeSummon(int count) {
    int cost = count == 1 ? 160 : 1500;
    if (playerGems < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gems tidak cukup!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() {
      playerGems -= cost;
      qSummonDone = true;
    });

    List<HeroItem> pulledHeroes = [];
    for (int i = 0; i < count; i++) {
      HeroItem drawn = _rollHero();
      pulledHeroes.add(drawn);
      playerInventory.add(drawn);
    }

    widget.onStateChanged();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GachaRevealScreen(results: pulledHeroes)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF33145A), Color(0xFF120E29)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(12)),
                      child: const Text('SUMMON BANNER', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    const SizedBox(height: 16),
                    const Text('SUN EMPRESS AURELIA', style: TextStyle(fontSize: 26, fontWeight: FontWeight.black, color: Colors.white)),
                    const Text('SSR Rate Up 5% | Garansi SSR di Pull ke-10', style: TextStyle(color: Colors.amberAccent, fontSize: 12)),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pity Progress:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('$pityCounter / 10', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(value: pityCounter / 10, color: const Color(0xFFFFD700), backgroundColor: Colors.white10, minHeight: 8),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1A3A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF00E5FF)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _executeSummon(1),
                  child: const Column(
                    children: [
                      Text('1x SUMMON', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text('💎 160', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _executeSummon(10),
                  child: const Column(
                    children: [
                      Text('10x SUMMON', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 4),
                      Text('💎 1500', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class GachaRevealScreen extends StatefulWidget {
  final List<HeroItem> results;
  const GachaRevealScreen({super.key, required this.results});

  @override
  State<GachaRevealScreen> createState() => _GachaRevealScreenState();
}

class _GachaRevealScreenState extends State<GachaRevealScreen> {
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _revealed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: !_revealed
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFFFD700)),
                  SizedBox(height: 20),
                  Text('MEMANGGIL HERO...', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text('HASIL SUMMON', style: TextStyle(fontSize: 22, fontWeight: FontWeight.black, color: Colors.white)),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 10, mainAxisSpacing: 10),
                        itemCount: widget.results.length,
                        itemBuilder: (ctx, i) {
                          final hero = widget.results[i];
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF16122C),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: hero.rarityColor, width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(radius: 26, backgroundColor: hero.themeColor, child: Text(hero.name[0], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                const SizedBox(height: 8),
                                Text(hero.rarityStr, style: TextStyle(color: hero.rarityColor, fontWeight: FontWeight.black, fontSize: 12)),
                                Text(hero.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                Text(hero.title, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('AMBIL SEMUA', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class CollectionScreen extends StatefulWidget {
  final VoidCallback onStateChanged;
  const CollectionScreen({super.key, required this.onStateChanged});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  void _levelUpHero(HeroItem hero) {
    int cost = hero.level * 200;
    if (playerGold < cost) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gold tidak cukup!'), backgroundColor: Colors.redAccent));
      return;
    }

    setState(() {
      playerGold -= cost;
      hero.level++;
    });
    widget.onStateChanged();
  }

  void _showEquipmentPicker(HeroItem hero, String type) {
    final availableEq = equipmentInventory.where((e) => e.type == type).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16122C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PILIH ${type.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
              const SizedBox(height: 10),
              if (availableEq.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Tidak ada perlengkapan tersedia.', style: TextStyle(color: Colors.white54)),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableEq.length,
                    itemBuilder: (ctx, i) {
                      final eq = availableEq[i];
                      return ListTile(
                        leading: Icon(type == 'Weapon' ? Icons.shield : Icons.security, color: eq.rarityColor),
                        title: Text(eq.name, style: TextStyle(color: eq.rarityColor, fontWeight: FontWeight.bold)),
                        subtitle: Text('+${eq.bonusAtk} ATK | +${eq.bonusHp} HP', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                        onTap: () {
                          setState(() {
                            if (type == 'Weapon') hero.equippedWeapon = eq;
                            if (type == 'Armor') hero.equippedArmor = eq;
                          });
                          widget.onStateChanged();
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('KOLEKSI HERO (${playerInventory.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: playerInventory.length,
              itemBuilder: (ctx, i) {
                final hero = playerInventory[i];
                int upgradeCost = hero.level * 200;

                return Card(
                  color: const Color(0xFF16122C),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: hero.rarityColor.withOpacity(0.4))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(backgroundColor: hero.themeColor, child: Text(hero.name[0], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${hero.name} (Lvl ${hero.level})', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  Text('HP: ${hero.currentHp} | ATK: ${hero.currentAtk}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700)),
                              onPressed: () => _levelUpHero(hero),
                              child: Text('UP ($upgradeCost G)', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white12, height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(side: BorderSide(color: hero.equippedWeapon?.rarityColor ?? Colors.white24)),
                                icon: const Icon(Icons.fitness_center, size: 14),
                                label: Text(hero.equippedWeapon?.name ?? 'Senjata', style: TextStyle(fontSize: 11, color: hero.equippedWeapon != null ? hero.equippedWeapon!.rarityColor : Colors.white54)),
                                onPressed: () => _showEquipmentPicker(hero, 'Weapon'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(side: BorderSide(color: hero.equippedArmor?.rarityColor ?? Colors.white24)),
                                icon: const Icon(Icons.shield, size: 14),
                                label: Text(hero.equippedArmor?.name ?? 'Armor', style: TextStyle(fontSize: 11, color: hero.equippedArmor != null ? hero.equippedArmor!.rarityColor : Colors.white54)),
                                onPressed: () => _showEquipmentPicker(hero, 'Armor'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BattleScreen extends StatefulWidget {
  final VoidCallback onStateChanged;
  const BattleScreen({super.key, required this.onStateChanged});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  HeroItem? activeHero;
  int selectedBossIdx = 0;
  late int enemyHp;
  late int enemyMaxHp;
  int playerHp = 1000;
  int playerMaxHp = 1000;
  bool inBattle = false;
  String log = 'Pilih Boss dan mulai bertarung!';

  @override
  void initState() {
    super.initState();
    enemyMaxHp = bossList[selectedBossIdx].hp;
    enemyHp = enemyMaxHp;
  }

  void _startBattle() {
    if (playerInventory.isEmpty) return;
    setState(() {
      activeHero = playerInventory.first;
      playerMaxHp = activeHero!.currentHp;
      playerHp = playerMaxHp;
      enemyMaxHp = bossList[selectedBossIdx].hp;
      enemyHp = enemyMaxHp;
      inBattle = true;
      log = 'Pertempuran Melawan ${bossList[selectedBossIdx].name} Dimulai!';
    });
  }

  void _attack() {
    if (!inBattle || activeHero == null) return;

    final rand = Random();
    final boss = bossList[selectedBossIdx];
    int dmg = activeHero!.currentAtk + rand.nextInt(40);
    int enemyDmg = boss.atk + rand.nextInt(20);

    setState(() {
      enemyHp = max(0, enemyHp - dmg);
      log = '${activeHero!.name} menyerang ${boss.name} sebesar $dmg DMG!';

      if (enemyHp <= 0) {
        inBattle = false;
        qBattleDone = true;
        playerGems += boss.gemReward;
        playerGold += boss.goldReward;
        log = 'MENANG! Mendapat ${boss.gemReward} Gems & ${boss.goldReward} Gold!';
        widget.onStateChanged();
        return;
      }

      playerHp = max(0, playerHp - enemyDmg);
      log += '\n${boss.name} membalas $enemyDmg DMG!';

      if (playerHp <= 0) {
        inBattle = false;
        log = 'KALAH! Hero kamu gugur.';
      }
    });
  }

  void _usePotion() {
    if (!inBattle || hpPotions <= 0) return;
    setState(() {
      hpPotions--;
      playerHp = min(playerMaxHp, playerHp + 400);
      log = 'Menggunakan HP Potion! +400 HP restored.';
    });
    widget.onStateChanged();
  }

  @override
  Widget build(BuildContext context) {
    final currentBoss = bossList[selectedBossIdx];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (!inBattle) ...[
            DropdownButton<int>(
              value: selectedBossIdx,
              dropdownColor: const Color(0xFF16122C),
              isExpanded: true,
              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              items: List.generate(bossList.length, (idx) {
                return DropdownMenuItem(
                  value: idx,
                  child: Text('STAGE ${idx + 1}: ${bossList[idx].name}'),
                );
              }),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedBossIdx = val;
                    enemyMaxHp = bossList[val].hp;
                    enemyHp = enemyMaxHp;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF16122C), borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.adb, size: 60, color: currentBoss.color),
                      Text(currentBoss.name, style: TextStyle(color: currentBoss.color, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(value: enemyHp / enemyMaxHp, color: currentBoss.color, backgroundColor: Colors.white10),
                      Text('$enemyHp / $enemyMaxHp', style: const TextStyle(fontSize: 10, color: Colors.white54)),
                    ],
                  ),
                  const Divider(color: Colors.white12),
                  if (activeHero != null)
                    Column(
                      children: [
                        CircleAvatar(backgroundColor: activeHero!.themeColor, child: Text(activeHero!.name[0], style: const TextStyle(color: Colors.black))),
                        Text('${activeHero!.name} (Lvl ${activeHero!.level})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(value: playerHp / playerMaxHp, color: Colors.greenAccent, backgroundColor: Colors.white10),
                        Text('$playerHp / $playerMaxHp', style: const TextStyle(fontSize: 10, color: Colors.white54)),
                      ],
                    )
                  else
                    const Text('Tekan MULAI BATTLE', style: TextStyle(color: Colors.white38)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(log, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  onPressed: _startBattle,
                  child: const Text('MULAI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: inBattle && hpPotions > 0 ? _usePotion : null,
                  child: Text('POTION ($hpPotions)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: inBattle ? _attack : null,
                  child: const Text('SERANG!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ShopScreen extends StatefulWidget {
  final VoidCallback onStateChanged;
  const ShopScreen({super.key, required this.onStateChanged});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  void _buyPotion() {
    if (playerGold < 300) {
      _showMessage('Gold tidak cukup!');
      return;
    }
    setState(() {
      playerGold -= 300;
      hpPotions++;
      qShopDone = true;
    });
    widget.onStateChanged();
    _showMessage('Berhasil membeli 1x HP Potion!');
  }

  void _buyEquipmentChest() {
    if (playerGold < 1000) {
      _showMessage('Gold tidak cukup!');
      return;
    }

    final rand = Random();
    Equipment drawnEq = equipmentPool[rand.nextInt(equipmentPool.length)];

    setState(() {
      playerGold -= 1000;
      equipmentInventory.add(drawnEq);
      qShopDone = true;
    });
    widget.onStateChanged();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16122C),
        title: const Text('EQUIPMENT UNLOCKED!', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(drawnEq.type == 'Weapon' ? Icons.fitness_center : Icons.shield, color: drawnEq.rarityColor, size: 50),
            const SizedBox(height: 10),
            Text(drawnEq.name, style: TextStyle(color: drawnEq.rarityColor, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('${drawnEq.type} | +${drawnEq.bonusAtk} ATK | +${drawnEq.bonusHp} HP', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK', style: TextStyle(color: Colors.amber))),
        ],
      ),
    );
  }

  void _buyGemsPack() {
    if (playerGold < 5000) {
      _showMessage('Gold tidak cukup!');
      return;
    }
    setState(() {
      playerGold -= 5000;
      playerGems += 500;
      qShopDone = true;
    });
    widget.onStateChanged();
    _showMessage('Berhasil menukar 5000 Gold dengan 500 Gems!');
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.amber));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BLACKSMITH & SHOP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildShopCard(
            title: 'HP Potion',
            subtitle: 'Pemulih +400 HP saat pertempuran',
            price: '300 Gold',
            icon: Icons.science,
            iconColor: Colors.greenAccent,
            onTap: _buyPotion,
          ),
          const SizedBox(height: 12),
          _buildShopCard(
            title: 'Equipment Chest',
            subtitle: 'Mendapatkan Senjata / Armor acak (R - SSR)',
            price: '1000 Gold',
            icon: Icons.card_giftcard,
            iconColor: Colors.amber,
            onTap: _buyEquipmentChest,
          ),
          const SizedBox(height: 12),
          _buildShopCard(
            title: 'Gems Pack (500 Gems)',
            subtitle: 'Tukar Gold untuk menambah saldo Gems',
            price: '5000 Gold',
            icon: Icons.diamond,
            iconColor: Colors.cyanAccent,
            onTap: _buyGemsPack,
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard({
    required String title,
    required String subtitle,
    required String price,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF16122C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: iconColor.withOpacity(0.3))),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700)),
          onPressed: onTap,
          child: Text(price, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
        ),
      ),
    );
  }
}

class QuestScreen extends StatefulWidget {
  final VoidCallback onStateChanged;
  const QuestScreen({super.key, required this.onStateChanged});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DAILY QUESTS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildQuestCard(
            title: 'Lakukan 1x Summon',
            reward: '💎 100 Gems',
            isDone: qSummonDone,
          ),
          const SizedBox(height: 12),
          _buildQuestCard(
            title: 'Menangkan 1x Battle',
            reward: '💰 500 Gold',
            isDone: qBattleDone,
          ),
          const SizedBox(height: 12),
          _buildQuestCard(
            title: 'Beli 1 Item di Shop',
            reward: '🧪 1x HP Potion',
            isDone: qShopDone,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestCard({required String title, required String reward, required bool isDone}) {
    return Card(
      color: const Color(0xFF16122C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isDone ? Colors.greenAccent : Colors.white12)),
      child: ListTile(
        leading: Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? Colors.greenAccent : Colors.white38),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text('Hadiah: $reward', style: const TextStyle(color: Colors.amber, fontSize: 11)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDone ? Colors.green.withOpacity(0.2) : Colors.white10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            isDone ? 'SELESAI' : 'BELUM',
            style: TextStyle(color: isDone ? Colors.greenAccent : Colors.white38, fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
