import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const WempiPromptBuilderApp());

class WempiPromptBuilderApp extends StatelessWidget {
  const WempiPromptBuilderApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'WEMPI PROMPT BUILDER V2',
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
        home: const AppHome(),
      );
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [PromptBuilderPage(), VideoToPromptPage()];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'Prompt Builder'),
          NavigationDestination(icon: Icon(Icons.video_library_outlined), label: 'Video to Prompt'),
        ],
      ),
    );
  }
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
  final surface = TextEditingController();
  final combatDna = TextEditingController();
  final shortChoreo = TextEditingController();
  final timing = TextEditingController();
  final camera = TextEditingController();
  final lighting = TextEditingController();
  final style = TextEditingController();
  final dialogue = TextEditingController();
  final negative = TextEditingController();

  String format = 'DUA JALAN SANG JUARA';
  String combatType = '1 VS 1';
  String martialStyle = 'CUSTOM / FOLLOW INPUT';
  String duration = '15 seconds';
  String ratio = '16:9';
  String language = 'English';
  int opponentCount = 1;
  final List<TextEditingController> opponents = [TextEditingController()];

  @override
  void dispose() {
    for (final c in [
      title,
      mainCharacter,
      location,
      surface,
      combatDna,
      shortChoreo,
      timing,
      camera,
      lighting,
      style,
      dialogue,
      negative,
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

  String _or(TextEditingController c, String fallback) {
    final value = c.text.trim();
    return value.isEmpty ? fallback : value;
  }

  String _orText(String value, String fallback) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  String _cast() {
    final lines = <String>[];
    lines.add('Image1 = ${_or(mainCharacter, 'Main Fighter')}');
    for (int i = 0; i < opponents.length; i++) {
      lines.add('Image${i + 2} = ${_or(opponents[i], 'Opponent ${i + 1}')}');
    }
    return lines.join('\n');
  }

  String _combatRules() {
    switch (combatType) {
      case '1 VS MANY':
        return '''1 VS MANY COMBAT:\nMaintain clear spatial continuity between the main fighter and every opponent. Opponents attack from readable different angles with logical target switching, spacing and reactions. Avoid identical synchronized attacks unless explicitly requested. No duplicate fighters, spawning, disappearing or identity swapping.''';
      case 'MANY VS MANY':
        return '''MANY VS MANY COMBAT:\nMaintain clear team relationships, readable positions and spatial continuity. Characters react to nearby actions and do not randomly merge, duplicate or switch identities. Avoid chaotic crowd behavior unless explicitly requested.''';
      default:
        return '''1 VS 1 COMBAT:\nOnly the selected two fighters participate. Maintain a clear spatial relationship throughout the action. No additional fighters, duplicates, spawning, disappearing or identity swapping.''';
    }
  }

  String _styleGuidance() {
    final s = martialStyle.toLowerCase();
    if (s.contains('wushu')) {
      return 'Use authentic Wushu movement language: fast fluid footwork, rhythm changes, angle changes, feints, clean explosive entries, controlled rotations and believable recovery.';
    }
    if (s.contains('karate')) {
      return 'Use authentic Karate movement language: disciplined stance, distance control, sharp entries, clean combinations, efficient pivots, controlled kicks and believable retraction.';
    }
    if (s.contains('silat')) {
      return 'Use authentic Pencak Silat movement language: low balanced footwork, angular entries, evasive body movement, sweeps, redirects and flowing transitions with realistic weight transfer.';
    }
    if (s.contains('taekwondo')) {
      return 'Use authentic Taekwondo movement language: dynamic footwork, distance management, fast kicks, chamber and retraction, angle changes and controlled landings.';
    }
    if (s.contains('kung fu')) {
      return 'Use authentic Kung Fu movement language: flowing combinations, directional changes, hand trapping, evasive steps, rotational attacks and grounded recovery.';
    }
    return 'Develop the choreography from the user input while preserving the named martial-arts style, believable footwork, weight transfer, rhythm changes, angles, feints, attacks, evasions, counters and continuous transitions.';
  }

  String _expandedChoreography() {
    final idea = _or(shortChoreo, 'The fighters exchange attacks, evasions and counters while continuously changing angles.');
    final dna = _or(combatDna, 'Fast tactical exchange with realistic timing, distance control and clean techniques.');
    final cameraText = _or(camera, 'Professional cinematic sports coverage with smooth tracking, readable action and controlled low tracking angles.');

    final timingText = timing.text.trim();
    if (timingText.isNotEmpty) {
      return '''Expand this short choreography into a complete continuous sequence without changing its core intent.\n\nUSER CHOREOGRAPHY:\n$idea\n\nCOMBAT DNA:\n$dna\n\nSTYLE GUIDANCE:\n${_styleGuidance()}\n\nTIMING FRAMEWORK:\n$timingText\n\nCAMERA INTEGRATION:\n$cameraText\n\nThe sequence must develop naturally through setup, approach, attack, reaction, evasion or block, counter, repositioning and immediate continuation. Preserve spatial continuity and realistic body mechanics. Do not invent unrelated story beats.''';
    }

    return '''Expand this short choreography into a complete continuous sequence without changing its core intent.\n\nUSER CHOREOGRAPHY:\n$idea\n\nCOMBAT DNA:\n$dna\n\nSTYLE GUIDANCE:\n${_styleGuidance()}\n\nAUTO TIMING:\nBuild a clear beginning, escalation, counter exchange and continuation across the full $duration duration. Use logical beat progression rather than random movements.\n\nCAMERA INTEGRATION:\n$cameraText\n\nThe sequence must develop naturally through setup, approach, attack, reaction, evasion or block, counter, repositioning and immediate continuation. Preserve spatial continuity and realistic body mechanics. Do not invent unrelated story beats.''';
  }

  String _environment() {
    final loc = _or(location, 'Indoor international martial arts arena');
    final surf = _or(surface, 'Official competition surface appropriate to the selected martial art');

    if (format == 'DUA JALAN SANG JUARA') {
      return '''Environment:\n$loc.\n$surf.\nPacked audience.\nLarge LED screen above the arena showing the live ${_or(title, 'match')} match.\nKeep the arena and competition surface consistent throughout the scene.''';
    }

    if (format == 'STREET FIGHT') {
      return '''Environment:\n$loc.\nThe environment is adapted naturally to the scene and provides believable obstacles, ground interaction and movement space.\nNo competition arena or sports audience unless explicitly requested.\nKeep the location layout spatially consistent throughout the scene.''';
    }

    return '''Environment:\n$loc.\n$surf.\nAdapt the environment to the scene requirements while maintaining strong spatial continuity.''';
  }

  String _visualStyle() {
    if (style.text.trim().isNotEmpty) return style.text.trim();
    return '''Ultra realistic.\nNatural imperfect skin.\nReal Indonesian human actors.\nSubtle halftone shading (color).\nNo cartoon, no anime, no CGI.\nRealistic anatomy, weight, gravity, contact, foot placement and ground interaction.\nProfessional cinematic image quality.''';
  }

  String _defaultNegative() {
    if (negative.text.trim().isNotEmpty) return negative.text.trim();
    if (format == 'STREET FIGHT') {
      return 'cartoon, anime, CGI, unrealistic physics, floating, teleportation, duplicate characters, identity swapping, spawning, disappearing, rubber limbs, broken anatomy, freeze ending, static pose';
    }
    return 'boxing ring, gloves, hand protectors, foot protectors, shin guards, body protector, exaggerated jump height, flying unrealistically, cartoon, anime, CGI, freeze ending, static pose';
  }

  String buildPrompt() {
    final promptTitle = _or(title, 'UNTITLED CINEMATIC ACTION SCENE');
    final cast = _cast();
    final choreo = _expandedChoreography();

    if (format == 'DUA JALAN SANG JUARA') {
      return '''Hasilkan video: Create a hyper-realistic live-action cinematic video, real Indonesian human actors, natural imperfect skin, subtle halftone shading (color), no cartoon, no CGI.
Generate video:
$cast

Character Mapping:
$cast
Keep all character appearances consistent with the reference images.

${_environment()}

Fight Style:
Authentic ${_orText(martialStyle, 'martial arts')} combat.
${_or(combatDna, 'Fast tactical exchange with rhythm changes, angle changes, feints, timing, and clean scoring techniques.')}

Camera:
${_or(camera, 'Professional sports broadcast. Smooth tracking. Low tracking angle. Focus on footwork and movement.')}
$ratio.

ACTION / CHOREOGRAPHY:
$choreo

TIMING:
${_or(timing, 'Continuous progression across the full duration, with no dead time between exchanges.')}

Visual Style:
${_visualStyle()}

Audio:
${_or(dialogue, 'Natural arena ambience, fast footsteps, realistic impacts and crowd reactions.')}

Negative Prompt:
${_defaultNegative()}

TITLE:
$promptTitle
FORMAT:
$duration, $ratio.
OUTPUT LANGUAGE:
$language''';
    }

    if (format == 'STREET FIGHT') {
      return '''Create a hyper-realistic live-action cinematic street-fight video, real human actors, natural imperfect skin, subtle halftone shading (color), no cartoon, no CGI.

TITLE:
$promptTitle

REFERENCE / CAST:
$cast
Keep all character appearances consistent with the reference images.

COMBAT TYPE:
$combatType

${_environment()}

FIGHT STYLE:
${_orText(martialStyle, 'Authentic mixed martial arts')}.
${_or(combatDna, 'Fast, hard and realistic close-range combat with tactical movement and believable reactions.')}

ACTION / CHOREOGRAPHY:
$choreo

CAMERA:
${_or(camera, 'Professional cinematic action camera, smooth tracking, dynamic low angles, readable spatial geography.')}

TIMING:
${_or(timing, 'Continuous escalation across the full duration. No dead time.')}

LIGHTING:
${_or(lighting, 'Natural cinematic lighting consistent with the location.')}

VISUAL STYLE:
${_visualStyle()}

DIALOGUE / AUDIO:
${_or(dialogue, 'Natural location ambience, footsteps, clothing movement, realistic impacts and environmental reactions.')}

PHYSICAL CONTINUITY:
Every acceleration must show believable foot placement, weight transfer, push-off, replant and immediate continuation. No teleportation, floating or unexplained position changes.

NEGATIVE PROMPT:
${_defaultNegative()}

OUTPUT LANGUAGE:
$language
FORMAT:
$duration, $ratio.''';
    }

    return '''Create a hyper-realistic live-action cinematic video.

TITLE:
$promptTitle

REFERENCE / CAST:
$cast
Keep all character appearances consistent with the reference images.

COMBAT TYPE:
$combatType

ENVIRONMENT:
${_environment()}

FIGHT STYLE:
${_orText(martialStyle, 'Authentic martial arts')}.
${_or(combatDna, 'Fast tactical combat with realistic movement and reactions.')}

ACTION / CHOREOGRAPHY:
$choreo

CAMERA:
${_or(camera, 'Cinematic tracking with clear spatial geography and readable action.')}

TIMING:
${_or(timing, 'Continuous action across the full duration.')}

LIGHTING:
${_or(lighting, 'Cinematic realistic lighting.')}

VISUAL STYLE:
${_visualStyle()}

DIALOGUE / AUDIO:
${_or(dialogue, 'Natural environmental ambience and realistic action sounds.')}

NEGATIVE PROMPT:
${_defaultNegative()}

OUTPUT LANGUAGE:
$language
FORMAT:
$duration, $ratio.''';
  }

  void generate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10131A),
      builder: (_) => PromptResultSheet(prompt: buildPrompt()),
    );
  }

  Widget field(String label, TextEditingController c, {int maxLines = 3, String? hint}) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextField(
          controller: c,
          maxLines: maxLines,
          decoration: InputDecoration(labelText: label, hintText: hint, alignLabelWithHint: true),
        ),
      );

  Widget section(String text) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 12),
        child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFF7EA9FF))),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('WEMPI PROMPT BUILDER V2'),
          centerTitle: true,
          backgroundColor: const Color(0xFF10131A),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
          children: [
            const Text('Cinematic Video Prompt Generator', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Short choreography in → complete cinematic prompt out.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 22),
            field('Project / Title', title, maxLines: 1),
            section('FORMAT / PROMPT ENGINE'),
            DropdownButtonFormField<String>(
              value: format,
              decoration: const InputDecoration(labelText: 'Format'),
              items: ['DUA JALAN SANG JUARA', 'STREET FIGHT', 'CUSTOM']
                  .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                  .toList(),
              onChanged: (v) => setState(() => format = v ?? format),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: combatType,
              decoration: const InputDecoration(labelText: 'Combat Type'),
              items: ['1 VS 1', '1 VS MANY', 'MANY VS MANY', 'CUSTOM']
                  .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                  .toList(),
              onChanged: (v) => setCombatType(v ?? combatType),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: martialStyle,
              decoration: const InputDecoration(labelText: 'Martial Arts / Movement Style'),
              items: ['CUSTOM / FOLLOW INPUT', 'WUSHU NANQUAN', 'KARATE', 'PENCAK SILAT', 'TAEKWONDO', 'KUNG FU']
                  .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                  .toList(),
              onChanged: (v) => setState(() => martialStyle = v ?? martialStyle),
            ),
            const SizedBox(height: 14),
            if (combatType != '1 VS 1') Row(
              children: [
                const Expanded(child: Text('Number of opponents')),
                IconButton(
                  onPressed: opponentCount > 1 ? () => setState(() { opponentCount--; syncOpponents(); }) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$opponentCount', style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () => setState(() { opponentCount++; syncOpponents(); }),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            field('Main Character', mainCharacter, maxLines: 1, hint: 'Example: Intan Permatasari'),
            for (int i = 0; i < opponentCount; i++) field('Opponent ${i + 1}', opponents[i], maxLines: 1),
            section('SCENE'),
            field('Location / Venue', location, hint: 'Leave flexible; the engine keeps it scene-specific.'),
            field('Competition Mat / Surface', surface, hint: 'Leave blank to auto-adapt to the selected style.'),
            field('Combat DNA', combatDna, hint: 'Example: fast tactical exchange, rhythm changes, angle changes...'),
            section('KOREO ENGINE'),
            field('Koreografi Singkat', shortChoreo, maxLines: 5, hint: 'Tulis singkat saja. Mesin akan mengembangkannya menjadi koreografi lengkap.'),
            field('Timing (optional)', timing, maxLines: 5, hint: 'Kosongkan untuk auto-timing.'),
            field('Camera (optional)', camera, maxLines: 4, hint: 'Kosongkan untuk gaya kamera default format.'),
            section('CINEMATIC CONTROL'),
            field('Lighting (optional)', lighting),
            field('Visual Style (optional)', style, maxLines: 4),
            field('Dialogue / Audio', dialogue, maxLines: 4),
            field('Negative Prompt (optional)', negative, maxLines: 5),
            section('OUTPUT'),
            Row(children: [
              Expanded(child: DropdownButtonFormField<String>(
                value: duration,
                decoration: const InputDecoration(labelText: 'Duration'),
                items: ['10 seconds', '15 seconds', '20 seconds', '30 seconds']
                    .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                    .toList(),
                onChanged: (v) => setState(() => duration = v ?? duration),
              )),
              const SizedBox(width: 12),
              Expanded(child: DropdownButtonFormField<String>(
                value: ratio,
                decoration: const InputDecoration(labelText: 'Aspect Ratio'),
                items: ['16:9', '21:9', '9:16', '1:1']
                    .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                    .toList(),
                onChanged: (v) => setState(() => ratio = v ?? ratio),
              )),
            ]),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: language,
              decoration: const InputDecoration(labelText: 'Output Language'),
              items: ['English', 'Indonesian', 'Japanese', 'Chinese']
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

class VideoToPromptPage extends StatefulWidget {
  const VideoToPromptPage({super.key});

  @override
  State<VideoToPromptPage> createState() => _VideoToPromptPageState();
}

class _VideoToPromptPageState extends State<VideoToPromptPage> {
  final picker = ImagePicker();
  final scene = TextEditingController();
  final camera = TextEditingController();
  final style = TextEditingController();
  final negative = TextEditingController();
  XFile? video;
  VideoPlayerController? controller;
  String metadata = '';

  @override
  void dispose() {
    controller?.dispose();
    scene.dispose();
    camera.dispose();
    style.dispose();
    negative.dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked == null) return;
    await controller?.dispose();
    final c = VideoPlayerController.file(File(picked.path));
    await c.initialize();
    setState(() {
      video = picked;
      controller = c;
      metadata = '${c.value.duration.inSeconds}s • ${c.value.size.width.toInt()}×${c.value.size.height.toInt()}';
    });
  }

  String buildVideoPrompt() {
    final fileName = video?.name ?? 'Selected video';
    final visual = style.text.trim().isEmpty
        ? 'Hyper-realistic live-action, natural human motion, realistic anatomy, weight, gravity and contact.'
        : style.text.trim();
    final cam = camera.text.trim().isEmpty
        ? 'Reconstruct the observed camera movement with smooth professional cinematic continuity.'
        : camera.text.trim();
    final sceneText = scene.text.trim().isEmpty
        ? 'Describe the visible action from the reference video faithfully, preserving the order of movement and spatial relationships.'
        : scene.text.trim();
    final neg = negative.text.trim().isEmpty
        ? 'cartoon, anime, CGI, duplicate characters, identity swapping, teleportation, floating, broken anatomy, freeze ending, static pose'
        : negative.text.trim();

    return '''VIDEO TO PROMPT — OFFLINE MODE

SOURCE VIDEO:
$fileName
$metadata

TASK:
Convert the reference video into a complete cinematic video-generation prompt. Preserve the visible choreography, sequence, character relationships, environment, timing and camera intent. Do not invent unrelated actions.

OBSERVED / USER DESCRIPTION:
$sceneText

ACTION / CHOREOGRAPHY:
Expand the observed movement into a continuous, production-ready sequence. Describe setup, movement, attack or interaction, reaction, repositioning, transitions and continuation in the same order as the reference video. Preserve realistic body mechanics and spatial continuity.

CAMERA:
$cam

VISUAL STYLE:
$visual

TIMING:
Use the source video's actual duration as the timing reference ($metadata). Divide the action into logical beats without freezing or unnecessary pauses.

AUDIO:
Reconstruct natural environmental ambience, footsteps, movement sounds, impacts and reactions appropriate to what is visibly happening.

NEGATIVE PROMPT:
$neg

IMPORTANT:
This APK module is offline. It reads the selected video's basic metadata, while the actual visual choreography description must be supplied in the field above. No paid API or cloud AI service is used.''';
  }

  void generate() {
    if (video == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih video terlebih dahulu.')));
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10131A),
      builder: (_) => PromptResultSheet(prompt: buildVideoPrompt()),
    );
  }

  Widget field(String label, TextEditingController c, {int maxLines = 3, String? hint}) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextField(
          controller: c,
          maxLines: maxLines,
          decoration: InputDecoration(labelText: label, hintText: hint, alignLabelWithHint: true),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('VIDEO TO PROMPT'),
          centerTitle: true,
          backgroundColor: const Color(0xFF10131A),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
          children: [
            const Text('Video → Cinematic Prompt', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Offline module — no paid API and no cloud AI.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: pickVideo,
              icon: const Icon(Icons.video_library),
              label: Text(video == null ? 'PILIH VIDEO' : 'GANTI VIDEO'),
            ),
            if (video != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF151922), borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.movie_outlined, color: Color(0xFF7EA9FF)),
                  const SizedBox(width: 10),
                  Expanded(child: Text('${video!.name}\n$metadata')),
                ]),
              ),
            ],
            const SizedBox(height: 20),
            const Text('KETERANGAN VIDEO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFF7EA9FF))),
            const SizedBox(height: 12),
            field('Deskripsi gerakan / koreografi', scene, maxLines: 6, hint: 'Contoh: dua fighter saling mendekat, fighter kiri melakukan jab lalu low kick, lawan menghindar dan melakukan counter...'),
            field('Camera', camera, maxLines: 4, hint: 'Kosongkan untuk camera reconstruction otomatis dari deskripsi.'),
            field('Visual Style', style, maxLines: 4, hint: 'Kosongkan untuk hyper-realistic live-action.'),
            field('Negative Prompt', negative, maxLines: 4),
            const SizedBox(height: 8),
            const Text('Catatan: versi ini tidak mengirim video ke internet. Karena itu aplikasi belum dapat “melihat” isi video secara otomatis; kamu memasukkan deskripsi singkat, lalu engine menyusunnya menjadi prompt lengkap.', style: TextStyle(color: Colors.white54, height: 1.4)),
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
              Row(children: [
                const Expanded(child: Text('GENERATED PROMPT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: prompt));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prompt copied')));
                  },
                  icon: const Icon(Icons.copy),
                ),
              ]),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF080A0D), borderRadius: BorderRadius.circular(12)),
                  child: SingleChildScrollView(controller: scroll, child: SelectableText(prompt)),
                ),
              ),
            ],
          ),
        ),
      );
}
