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
            filled: true,
            fillColor: const Color(0xFF151922),
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
  final choreographyIdea = TextEditingController();
  final extraStyle = TextEditingController();
  final dialogue = TextEditingController();
  final negative = TextEditingController();
  final referenceNotes = TextEditingController();

  String formatMode = 'Dua Jalan Sang Juara';
  String combatType = '1 VS 1';
  int opponentCount = 1;
  String duration = '10 seconds';
  String ratio = '16:9';
  String language = 'English';
  String intensity = 'Cinematic / High Impact';
  final List<TextEditingController> opponents = [TextEditingController()];

  @override
  void dispose() {
    for (final c in [
      title,
      mainCharacter,
      location,
      choreographyIdea,
      extraStyle,
      dialogue,
      negative,
      referenceNotes,
      ...opponents,
    ]) {
      c.dispose();
    }
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

  String clean(String value, String fallback) {
    final v = value.trim();
    return v.isEmpty ? fallback : v;
  }

  String modeDNA() {
    switch (formatMode) {
      case 'Street Fight':
        return '''STREET FIGHT DNA:
Free-form real-world confrontation. No tournament choreography and no sports-broadcast presentation unless explicitly requested. Use believable street fighting, environmental awareness, aggressive but physically grounded movement, realistic fatigue and reactions. The environment is part of the action, but characters remain anatomically and spatially coherent.''';
      case 'Custom':
        return '''CUSTOM MODE:
Follow the user's stated intent and preserve the requested visual identity. Do not impose tournament or street-fight rules unless the user explicitly asks for them.''';
      default:
        return '''DUA JALAN SANG JUARA DNA:
Cinematic live-action martial-arts drama with disciplined character continuity. When the scene is a formal competition, preserve a clear competition structure, readable exchanges, realistic martial-arts technique, respectful presentation and consistent venue continuity. Do not automatically turn the scene into a street fight.''';
    }
  }

  String combatRules() {
    if (combatType == '1 VS MANY') {
      return '''1 VS MANY RULES:
Only the selected main character and the listed opponents participate. Keep every opponent individually identifiable. Maintain readable spacing, target switching, foreground/background separation and believable repositioning. Do not let all opponents attack at the exact same time unless explicitly requested. No additional fighters, duplicates, spawning, disappearing or identity swapping.''';
    }
    if (combatType == 'MANY VS MANY') {
      return '''MANY VS MANY RULES:
Only the listed fighters participate. Preserve clear team relationships and individual identities. Keep nearby actions readable with logical spacing, reactions and movement paths. Do not create extra fighters or merge identities. No duplicates, spawning, disappearing or identity swapping.''';
    }
    if (combatType == 'CUSTOM') {
      return '''CUSTOM COMBAT RULES:
Use exactly the character count and relationships defined by the user. Never introduce unrequested fighters or duplicate an existing identity.''';
    }
    return '''1 VS 1 RULES:
Only the main character and the listed opponent participate. Maintain a clear spatial relationship throughout the action. No additional fighters, duplicates, spawning, disappearing or identity swapping.''';
  }

  String characterBlock() {
    final opponentLines = opponents.asMap().entries.map((entry) {
      final name = clean(entry.value.text, 'Opponent ${entry.key + 1}');
      return 'Opponent ${entry.key + 1} = $name';
    }).join('\n');
    return '''REFERENCE / CAST:
Main Character = ${clean(mainCharacter.text, 'Main Character')}
$opponentLines

CHARACTER CONSISTENCY:
Preserve the exact identity, face, hairstyle, body proportions, physique and clothing of each referenced character. Keep identity stable throughout the shot. No morphing, identity swapping or unexplained outfit changes.''';
  }

  String expandedChoreography() {
    final idea = clean(
      choreographyIdea.text,
      'The main character initiates a fast, controlled attack and the opponent responds with a believable defensive counter.',
    );

    final intensityLine = intensity == 'Controlled / Realistic'
        ? 'Use controlled, readable movement with realistic acceleration and recovery.'
        : intensity == 'Extreme Speed'
            ? 'Use very fast but physically believable acceleration, rapid direction changes and crisp reactions without teleportation.'
            : 'Use energetic cinematic movement, strong impact readability and fast but physically believable transitions.';

    if (formatMode == 'Street Fight') {
      return '''CHOREOGRAPHY EXPANSION:
User's core idea: $idea

Develop this short idea into a coherent street-fight sequence. Start from the characters' actual positions, establish who initiates the exchange, then connect attacks, evasions, counters, footwork, weight transfer, contact reactions and recovery into one continuous physical chain. Use the environment naturally when useful, while keeping every movement grounded and spatially consistent. $intensityLine Do not invent extra characters.''';
    }

    if (formatMode == 'Dua Jalan Sang Juara') {
      return '''CHOREOGRAPHY EXPANSION:
User's core idea: $idea

Develop the idea into a cinematic martial-arts sequence appropriate to Dua Jalan Sang Juara. Build a clear cause-and-effect exchange: initiation, defense/evasion, counter, reaction, repositioning and continuation. Preserve disciplined technique and believable balance, stance, distance, timing and recovery. If the location is a formal competition venue, keep the action readable as an official martial-arts contest and do not introduce street-fight behavior unless explicitly requested. $intensityLine''';
    }

    return '''CHOREOGRAPHY EXPANSION:
User's core idea: $idea

Expand the idea into a complete cinematic action sequence with logical initiation, reaction, counter, repositioning, impact and recovery. Follow the selected custom intent. $intensityLine''';
  }

  String timingBlock() {
    final seconds = duration.replaceAll(RegExp(r'[^0-9]'), '');
    if (seconds == '15') {
      return '''TIMING:
0-4s: Establish positions and begin the user's core action.
4-8s: Execute the main exchange with clear attack, defense and counter logic.
8-12s: Escalate the choreography with repositioning and decisive movement.
12-15s: Complete the exchange, show the reaction and hold a clean ending beat.''';
    }
    if (seconds == '20') {
      return '''TIMING:
0-5s: Establish positions and initiate the conflict.
5-10s: Develop the first exchange and defensive response.
10-15s: Escalate with counters, repositioning and a stronger action beat.
15-20s: Resolve the sequence with a clear reaction and cinematic ending beat.''';
    }
    if (seconds == '30') {
      return '''TIMING:
0-6s: Establish the environment, positions and initial intent.
6-13s: First attack and defense exchange.
13-20s: Counter sequence and repositioning.
20-26s: Main escalation and decisive action.
26-30s: Reaction, recovery and clean cinematic ending beat.''';
    }
    return '''TIMING:
0-3s: Establish positions and immediate intent.
3-6s: Execute the first attack and defensive response.
6-8s: Counter and reposition with clear cause-and-effect movement.
8-10s: Finish the exchange with a decisive action, reaction and clean ending beat.''';
  }

  String cameraBlock() {
    if (formatMode == 'Street Fight') {
      return '''CAMERA:
Use dynamic handheld-style cinematic coverage with motivated tracking, low-angle and side-angle movement when it improves impact. Keep both the attacker and target readable during fast movement. Avoid random camera motion, excessive shake, obstructed framing and cuts that break spatial continuity.''';
    }
    if (formatMode == 'Dua Jalan Sang Juara') {
      return '''CAMERA:
Use professional cinematic sports-drama coverage: establish the venue, then medium tracking and controlled close shots during key exchanges. Follow the action smoothly while preserving spatial orientation. Use dynamic push-ins or lateral tracking for impact, but do not let the camera hide the technique or break continuity.''';
    }
    return '''CAMERA:
Use cinematic coverage that follows the action naturally. Establish the location, maintain readable spatial relationships, then use motivated tracking, push-ins and close shots for key moments without random movement or continuity-breaking cuts.''';
  }

  String buildPrompt() {
    final main = clean(mainCharacter.text, 'Main Character');
    final venue = clean(location.text, 'Cinematic action location');
    final titleText = clean(title.text, 'UNTITLED CINEMATIC ACTION SCENE');
    final visual = clean(
      extraStyle.text,
      'Ultra-photorealistic live-action, realistic anatomy, realistic weight, gravity, contact, ground interaction, cinematic depth of field and natural lighting.',
    );
    final neg = clean(
      negative.text,
      'cartoon, anime, CGI look, plastic skin, exaggerated anatomy, extra limbs, duplicate characters, spawning, disappearing, identity swapping, teleportation, floating, impossible physics, broken hands, broken feet, unstable faces, random camera motion',
    );

    return '''CREATE A $duration ULTRA-REALISTIC CINEMATIC VIDEO.

TITLE:
$titleText

FORMAT:
$duration, $ratio, photorealistic live-action.
PROMPT MODE:
$formatMode

${characterBlock()}

LOCATION / VENUE:
$venue

${modeDNA()}

COMBAT TYPE:
$combatType

${combatRules()}

${expandedChoreography()}

${timingBlock()}

${cameraBlock()}

LIGHTING / VISUAL STYLE:
$visual

DIALOGUE:
${clean(dialogue.text, 'No dialogue unless explicitly requested.')}

REFERENCE NOTES:
${clean(referenceNotes.text, 'Preserve all supplied visual references consistently.')}

PHYSICAL CONTINUITY:
Every acceleration must show believable push-off, foot placement, weight transfer, replant, momentum, contact and recovery. Characters must remain grounded and maintain consistent position relative to the environment and each other. No teleportation, floating or unexplained position changes.

NEGATIVE PROMPT:
$neg

OUTPUT LANGUAGE:
$language'''.trim();
  }

  void generate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10131A),
      builder: (_) => PromptResultSheet(prompt: buildPrompt()),
    );
  }

  Widget field(String label, TextEditingController controller,
      {int maxLines = 3, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, hintText: hint, alignLabelWithHint: true),
      ),
    );
  }

  Widget section(String text) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Color(0xFF7EA9FF),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('WEMPI PROMPT BUILDER'),
          centerTitle: true,
          backgroundColor: const Color(0xFF10131A),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
          children: [
            const Text(
              'Cinematic Prompt Engine V2',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Write a short idea. The engine expands it into a structured cinematic prompt.',
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 22),
            field('Project / Title', title, maxLines: 1),
            section('PROMPT FORMAT'),
            DropdownButtonFormField<String>(
              value: formatMode,
              decoration: const InputDecoration(labelText: 'Project Format / Mode'),
              items: const ['Dua Jalan Sang Juara', 'Street Fight', 'Custom']
                  .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                  .toList(),
              onChanged: (v) => setState(() => formatMode = v ?? formatMode),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: combatType,
              decoration: const InputDecoration(labelText: 'Combat Type'),
              items: const ['1 VS 1', '1 VS MANY', 'MANY VS MANY', 'CUSTOM']
                  .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                  .toList(),
              onChanged: (v) => setCombatType(v ?? combatType),
            ),
            const SizedBox(height: 8),
            if (combatType != '1 VS 1')
              Row(
                children: [
                  const Expanded(child: Text('Number of opponents')),
                  IconButton(
                    onPressed: opponentCount > 1
                        ? () => setState(() {
                              opponentCount--;
                              syncOpponents();
                            })
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$opponentCount', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: () => setState(() {
                      opponentCount++;
                      syncOpponents();
                    }),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            field('Main Character', mainCharacter, maxLines: 1),
            for (int i = 0; i < opponentCount; i++)
              field('Opponent ${i + 1}', opponents[i], maxLines: 1),
            section('SCENE INPUT'),
            field('Location / Venue', location, hint: 'Where does the scene happen?'),
            field(
              'Short Choreography Idea',
              choreographyIdea,
              maxLines: 5,
              hint: 'Example: Kanza attacks fast, Adisaja evades and counters with a kick.',
            ),
            DropdownButtonFormField<String>(
              value: intensity,
              decoration: const InputDecoration(labelText: 'Action Intensity'),
              items: const [
                'Controlled / Realistic',
                'Cinematic / High Impact',
                'Extreme Speed',
              ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
              onChanged: (v) => setState(() => intensity = v ?? intensity),
            ),
            const SizedBox(height: 14),
            field(
              'Extra Visual Style (Optional)',
              extraStyle,
              maxLines: 4,
              hint: 'Leave blank to use the built-in realistic cinematic style.',
            ),
            field('Dialogue (Optional)', dialogue, maxLines: 4),
            field('Reference Notes (Optional)', referenceNotes, maxLines: 3),
            field('Negative Prompt (Optional)', negative, maxLines: 4),
            section('OUTPUT'),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: duration,
                    decoration: const InputDecoration(labelText: 'Duration'),
                    items: const ['10 seconds', '15 seconds', '20 seconds', '30 seconds']
                        .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                        .toList(),
                    onChanged: (v) => setState(() => duration = v ?? duration),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: ratio,
                    decoration: const InputDecoration(labelText: 'Aspect Ratio'),
                    items: const ['16:9', '21:9', '9:16', '1:1']
                        .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                        .toList(),
                    onChanged: (v) => setState(() => ratio = v ?? ratio),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: language,
              decoration: const InputDecoration(labelText: 'Output Language'),
              items: const ['English', 'Indonesian', 'Japanese', 'Chinese']
                  .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                  .toList(),
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
        expand: false,
        initialChildSize: .88,
        minChildSize: .5,
        maxChildSize: .96,
        builder: (_, scroll) => Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'GENERATED PROMPT V2',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: prompt));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Prompt copied')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF080A0D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    controller: scroll,
                    child: SelectableText(prompt),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
