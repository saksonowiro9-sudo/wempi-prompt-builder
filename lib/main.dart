import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const WempiPromptBuilderApp());

class WempiPromptBuilderApp extends StatelessWidget {
  const WempiPromptBuilderApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'WEMPI PROMPT BUILDER',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0D10),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4F8CFF),
        brightness: Brightness.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: const Color(0xFF151922),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: const PromptBuilderPage(),
  );
}

class PromptBuilderPage extends StatefulWidget {
  const PromptBuilderPage({super.key});
  @override
  State<PromptBuilderPage> createState() => _PromptBuilderPageState();
}

class _PromptBuilderPageState extends State<PromptBuilderPage> {
  final title = TextEditingController();
  final mainCharacter = TextEditingController();
  final location = TextEditingController();
  final combatDna = TextEditingController();
  final action = TextEditingController();
  final timing = TextEditingController();
  final camera = TextEditingController();
  final lighting = TextEditingController();
  final style = TextEditingController();
  final dialogue = TextEditingController();
  final negative = TextEditingController();

  String combatType = '1 VS 1';
  int opponentCount = 1;
  String duration = '10 seconds';
  String ratio = '16:9';
  String language = 'English';
  final List<TextEditingController> opponents = [TextEditingController()];

  @override
  void dispose() {
    for (final c in [
      title, mainCharacter, location, combatDna, action, timing, camera,
      lighting, style, dialogue, negative, ...opponents
    ]) { c.dispose(); }
    super.dispose();
  }

  void setCombatType(String value) {
    setState(() {
      combatType = value;
      if (value == '1 VS 1') opponentCount = 1;
      if (value == '1 VS MANY' && opponentCount < 2) opponentCount = 2;
      if (value == 'MANY VS MANY' && opponentCount < 2) opponentCount = 2;
      syncOpponents();
    });
  }

  void syncOpponents() {
    while (opponents.length < opponentCount) {
      opponents.add(TextEditingController());
    }
    while (opponents.length > opponentCount) {
      opponents.removeLast().dispose();
    }
  }

  String buildPrompt() {
    final opponentLines = opponents.asMap().entries.map((e) {
      final n = e.value.text.trim().isEmpty
          ? 'Opponent ${e.key + 1}' : e.value.text.trim();
      return 'Opponent ${e.key + 1} = $n';
    }).join('\n');

    final rules = combatType == '1 VS MANY' ? '''
1 VS MANY COMBAT:
The main fighter maintains clear spatial continuity while opponents attack from different angles.
Use logical target switching, repositioning, foreground/background separation and readable spacing.
Opponents do not attack in an identical synchronized pattern unless explicitly requested.
No duplicate fighters, spawning, disappearing or identity swapping.
''' : combatType == 'MANY VS MANY' ? '''
MANY VS MANY COMBAT:
Maintain clear team relationships and spatial continuity.
Characters occupy distinct positions and react to nearby actions.
Avoid random crowd behavior, duplicate fighters, spawning, disappearing or identity swapping.
''' : '''
1 VS 1 COMBAT:
Only the selected two fighters participate.
Maintain a clear spatial relationship throughout the action.
No additional fighters, duplicates, spawning, disappearing or identity swapping.
''';

    return '''
CREATE A $duration ULTRA-REALISTIC CINEMATIC VIDEO.

TITLE:
${title.text.trim().isEmpty ? 'UNTITLED CINEMATIC ACTION SCENE' : title.text.trim()}

FORMAT:
$duration, $ratio, photorealistic live-action.

REFERENCE / CAST:
Main Character = ${mainCharacter.text.trim().isEmpty ? 'Main Fighter' : mainCharacter.text.trim()}
$opponentLines

COMBAT TYPE:
$combatType

CHARACTER:
Preserve the identity, face, hairstyle, body proportions, physique and clothing of each referenced character.
No character morphing. No identity swapping. No outfit changes unless explicitly requested.

LOCATION:
${location.text.trim()}

COMBAT DNA:
${combatDna.text.trim()}

$rules

ACTION / CHOREOGRAPHY:
${action.text.trim()}

TIMING:
${timing.text.trim()}

CAMERA:
${camera.text.trim()}

LIGHTING:
${lighting.text.trim()}

VISUAL STYLE:
${style.text.trim().isEmpty ? 'Ultra-photorealistic live-action, realistic anatomy, realistic weight, gravity, contact and ground interaction, cinematic depth of field, realistic lighting and shadows.' : style.text.trim()}

DIALOGUE:
${dialogue.text.trim()}

PHYSICAL CONTINUITY:
Every acceleration must show believable foot placement, weight transfer, push-off, movement, replant and immediate continuation.
No teleportation, floating, impossible physics or unexplained position changes.

NEGATIVE PROMPT:
${negative.text.trim()}

OUTPUT LANGUAGE:
$language
'''.trim();
  }

  void generate() {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: const Color(0xFF10131A),
      builder: (_) => PromptResultSheet(prompt: buildPrompt()),
    );
  }

  Widget field(String label, TextEditingController c, {int maxLines = 3}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c, maxLines: maxLines,
        decoration: InputDecoration(labelText: label, alignLabelWithHint: true),
      ),
    );

  Widget section(String text) => Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 12),
    child: Text(text, style: const TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2,
      color: Color(0xFF7EA9FF),
    )),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('WEMPI PROMPT BUILDER'),
      centerTitle: true, backgroundColor: const Color(0xFF10131A),
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
      children: [
        const Text('Cinematic Video Prompt Generator',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Build 1 VS 1, 1 VS MANY, or MANY VS MANY prompts locally.',
          style: TextStyle(color: Colors.white60)),
        const SizedBox(height: 22),
        field('Project / Title', title, maxLines: 1),
        section('COMBAT SETUP'),
        DropdownButtonFormField<String>(
          value: combatType,
          decoration: const InputDecoration(labelText: 'Combat Type'),
          items: ['1 VS 1', '1 VS MANY', 'MANY VS MANY', 'CUSTOM']
            .map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
          onChanged: (v) => setCombatType(v ?? combatType),
        ),
        const SizedBox(height: 14),
        if (combatType != '1 VS 1') Row(children: [
          const Expanded(child: Text('Number of opponents')),
          IconButton(
            onPressed: opponentCount > 1 ? () {
              setState(() { opponentCount--; syncOpponents(); });
            } : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text('$opponentCount', style: const TextStyle(fontSize: 18)),
          IconButton(
            onPressed: () {
              setState(() { opponentCount++; syncOpponents(); });
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ]),
        field('Main Character', mainCharacter, maxLines: 1),
        for (int i = 0; i < opponentCount; i++)
          field('Opponent ${i + 1}', opponents[i], maxLines: 1),
        section('SCENE'),
        field('Location / Venue', location),
        field('Combat DNA', combatDna),
        field('Action / Choreography', action, maxLines: 5),
        field('Timing', timing, maxLines: 5),
        field('Camera', camera, maxLines: 5),
        field('Lighting', lighting),
        field('Visual Style', style, maxLines: 4),
        field('Dialogue', dialogue, maxLines: 4),
        field('Negative Prompt', negative, maxLines: 5),
        section('OUTPUT'),
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(
            value: duration,
            decoration: const InputDecoration(labelText: 'Duration'),
            items: ['10 seconds', '15 seconds', '20 seconds', '30 seconds']
              .map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
            onChanged: (v) => setState(() => duration = v ?? duration),
          )),
          const SizedBox(width: 12),
          Expanded(child: DropdownButtonFormField<String>(
            value: ratio,
            decoration: const InputDecoration(labelText: 'Aspect Ratio'),
            items: ['16:9', '21:9', '9:16', '1:1']
              .map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
            onChanged: (v) => setState(() => ratio = v ?? ratio),
          )),
        ]),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: language,
          decoration: const InputDecoration(labelText: 'Output Language'),
          items: ['English', 'Indonesian', 'Japanese', 'Chinese']
            .map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
          onChanged: (v) => setState(() => language = v ?? language),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: generate,
      icon: const Icon(Icons.auto_awesome),
      label: const Text('GENERATE PROMPT'),
    ),
  );
}

class PromptResultSheet extends StatelessWidget {
  final String prompt;
  const PromptResultSheet({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    expand: false, initialChildSize: .88, minChildSize: .5, maxChildSize: .96,
    builder: (_, scroll) => Padding(
      padding: const EdgeInsets.all(18),
      child: Column(children: [
        Row(children: [
          const Expanded(child: Text('GENERATED PROMPT',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: prompt));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prompt copied')),
              );
            },
            icon: const Icon(Icons.copy),
          ),
        ]),
        const SizedBox(height: 10),
        Expanded(child: Container(
          width: double.infinity, padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF080A0D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(child: SelectableText(prompt)),
        )),
      ]),
    ),
  );
}
