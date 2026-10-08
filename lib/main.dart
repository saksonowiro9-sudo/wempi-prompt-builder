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

  String format = 'STREET FIGHT';
  String combatType = '1 VS MANY';
  String martialStyle = 'CUSTOM / FOLLOW INPUT';
  String duration = '10 seconds';
  String ratio = '16:9';
  String language = 'English';
  int opponentCount = 5;
  final List<TextEditingController> opponents = [
    TextEditingController(text: 'Criminal 1'),
    TextEditingController(text: 'Criminal 2'),
    TextEditingController(text: 'Criminal 3'),
    TextEditingController(text: 'Criminal 4'),
    TextEditingController(text: 'Criminal 5'),
  ];

  @override
  void initState() {
    super.initState();
    _loadStreetFightDefaults();
  }

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
      opponents.add(TextEditingController(text: 'Opponent ${opponents.length + 1}'));
    }
    while (opponents.length > opponentCount) {
      opponents.removeLast().dispose();
    }
  }

  String _or(TextEditingController c, String fallback) {
    final value = c.text.trim();
    return value.isEmpty ? fallback : value;
  }

  void _set(TextEditingController c, String value) {
    c.text = value;
  }

  void clearAll() {
    for (final c in [title, mainCharacter, location, surface, combatDna, shortChoreo, timing, camera, lighting, style, dialogue, negative, ...opponents]) {
      c.clear();
    }
    setState(() {
      combatType = 'CUSTOM';
      martialStyle = 'CUSTOM / FOLLOW INPUT';
      duration = '15 seconds';
      ratio = '16:9';
      language = 'English';
      opponentCount = 1;
      syncOpponents();
    });
  }

  void applyFormatDefaults(String value) {
    if (value == 'STREET FIGHT') {
      _loadStreetFightDefaults();
      setState(() => format = value);
    } else if (value == 'DUA JALAN SANG JUARA') {
      _loadDjsjDefaults();
      setState(() => format = value);
    } else {
      clearAll();
      setState(() => format = value);
    }
  }

  void _loadStreetFightDefaults() {
    _set(title, 'KANZA vs MANY OPENED — EXTREME REALISTIC TAIJUTSU — MODERN SPORTS COMPLEX PARKING AREA');
    _set(mainCharacter, 'Kanza');
    _set(location, 'Modern Indonesian sports-complex parking area during late afternoon transitioning into early evening.');
    _set(surface, 'Large concrete parking area, realistic asphalt and concrete surfaces.');
    _set(combatDna, """Extreme-speed anime-inspired martial arts translated into physically believable live-action movement.

Kanza fights with extremely fluid, connected movement:
fast hand combinations, palm parries, body slips, evasive footwork, short counters, low kicks, roundhouse kicks, directional changes and rapid repositioning.

Her movement must feel like one continuous physical system.""");
    _set(shortChoreo, """0.0–2.0 SECONDS — OPENING COLLISION
Start with a cinematic wide shot of the parking area.
Criminal 1 suddenly closes distance and throws a fast straight punch.
Kanza immediately slips her head outside the punch, redirects the attacking arm with a short palm parry, then steps inside with a rapid cross counter.
Before Criminal 1 can recover, Kanza rotates her hips into a compact body hook, immediately re-plants her foot and delivers a fast low kick.
Criminal 2 attacks from Kanza's left side before she fully resets.
Kanza uses the recovery of the low kick to rotate away from Criminal 2, slipping the incoming strike and redirecting the arm with an inside parry.
She finishes the sequence with a short elbow-range counter and instantly changes direction.
No reset.

2.0–4.2 SECONDS — EVASION + JUMP TRANSITION
Criminal 3 enters aggressively from the opposite side.
Kanza turns toward him while moving backward.
She parries the incoming attack, drops her center of gravity and performs a fast body slip.
Criminal 3 follows with a sweeping attack.
Kanza plants one foot, compresses the knee and explosively pushes off diagonally.
She performs a realistic evasive diagonal jump over the sweeping attack.
At the closest near-miss moment, briefly introduce a very short 0.3-second micro slow-motion.
Show the dangerous proximity clearly.
Immediately snap back to extreme speed.
Kanza lands with the first foot absorbing impact through the knee, second foot stabilizing, hips rotating naturally.
Without stopping, she launches directly into a fast roundhouse toward Criminal 3.
The kick remains physically grounded and realistic.

4.2–6.8 SECONDS — TARGET SWITCH
Before Kanza can fully complete the kick recovery, Criminal 4 attacks from behind her right side.
Kanza retracts the kicking leg, plants it firmly and immediately turns her torso.
She slips the incoming strike by centimeters.
Short palm redirect.
Fast counter combination.
Criminal 4 blocks the first counter.
Kanza immediately changes level, ducks underneath the guard and steps laterally.
She delivers a compact body counter followed by a low kick.
She re-plants and uses the momentum to rotate toward the opposite side.
Criminal 5 enters at the exact moment.
Kanza performs an explosive direction change, crosses the short distance and intercepts Criminal 5 with a rapid parry → counter → body rotation → fast kick combination.
Criminal 5 is forced backward by the physical impact and loses balance naturally.
No exaggerated flying.

6.8–8.4 SECONDS — FIVE-TARGET SCRAMBLE
The remaining criminals rapidly close the distance.
Instead of attacking one by one, they create a chaotic multi-angle pressure sequence.
Kanza moves continuously:
attack → parry → counter → side step → body slip → low kick → replant → target switch → short counter.
She uses several short 1–3 meter bursts.
Each acceleration begins with visible foot push-off and knee extension.
Fast directional movement creates short natural motion blur.
Kanza crosses between attackers rather than staying in one position.
One attacker briefly passes through the foreground while another enters from the opposite side.
Kanza immediately changes direction and avoids the incoming strike.
No pause.
No fighting reset.

8.4–10.0 SECONDS — FINAL SPEED RAMP
Criminal 2 suddenly attacks from Kanza's blind side.
Kanza notices the movement at the last possible moment.
Extreme speed.
Incoming strike passes extremely close to her face.
Brief 0.3-second micro slow-motion on the near miss: eyes tracking the attack, head slipping away, strike passing centimeters from her face.
Immediately snap back to extreme speed.
Kanza performs:
side slip → palm redirect → body rotation → rapid counter → roundhouse → hard replant.
As she completes the roundhouse, another criminal begins entering the frame.
Kanza immediately turns toward the new threat.
END MID-FIGHT.
Do NOT show a victory pose.
Do NOT show everyone defeated.
Do NOT end with Kanza standing still.
The final frame must feel like the fight is continuing.""");
    _set(timing, """10 seconds total.
0.0–2.0s opening collision.
2.0–4.2s evasion + jump transition.
4.2–6.8s target switch.
6.8–8.4s five-target scramble.
8.4–10.0s final speed ramp.
Micro slow-motion only during selected near-miss moments; combat never stops.""");
    _set(camera, """Replace the previous close handheld camera with a more cinematic reactive action-film camera.
The camera remains physically operated and always follows the action, but with smoother controlled movement.

0.0–2.0s: wide establishing shot approximately 5–7 meters away, then smooth lateral tracking toward the fight.
2.0–4.2s: medium-full-body side tracking shot; slightly lower angle during the evasive diagonal jump while keeping the entire body visible.
4.2–6.8s: controlled 3/4 front tracking shot; camera moves backward while Kanza advances; short smooth orbit during direction change.
6.8–8.4s: temporarily widen to capture multiple attackers; brief elevated angle for approximately 0.5–0.8 seconds, then return to ground level.
8.4–10.0s: dynamic low 3/4 angle during final speed ramp; track head slip and roundhouse; finish with smooth full-body pullback as another attacker enters frame.

CAMERA RULE:
The character moves first. The camera reacts second.
Camera reaction approximately 0.1–0.2 seconds behind the action.
Use smooth tracking, controlled lateral movement, short orbit, brief low angle, brief elevated perspective and smooth pullback.
Avoid excessive handheld shake.
No camera teleportation.
No impossible camera movement.
No random cuts.
No sudden location changes.
Maintain spatial continuity at all times.""");
    _set(lighting, 'Warm late-afternoon light gradually mixing with cooler early-evening artificial lighting. Realistic directional shadows and subtle parking lights.');
    _set(style, """Ultra-photorealistic live-action.
Real human performers.
Realistic anatomy.
Realistic weight, gravity, contact and ground interaction.
Modern Indonesian cinematic action film.
Professional martial-arts stunt choreography.
Natural directional motion blur.
Cinematic depth of field.
Realistic lighting and shadows.
NO CGI-looking humans.
NO anime characters.
NO cartoon.
NO 3D animation.
NO supernatural powers.
NO teleportation.
NO floating.
NO wire-fu.
NO impossible jumps.
NO exaggerated flying bodies.

EXTREME SPEED PHYSICS:
Every acceleration must follow:
FOOT PLANT → KNEE COMPRESSION → PHYSICAL PUSH-OFF → EXPLOSIVE ACCELERATION → SHORT DIRECTIONAL MOTION BLUR → DISTANCE CROSSING → HARD REPLANT → ATTACK → CONTACT / NEAR MISS → IMMEDIATE NEXT MOVEMENT.
No teleportation. The viewer must still perceive the physical transition between every movement. Use short directional speed blur only during explosive acceleration. Keep close-range hand and body actions readable.

SPEED RAMP LOCK:
EXTREME FAST → DANGEROUS NEAR MISS → 0.3 SECOND MICRO SLOW → DODGE → INSTANT SNAP BACK TO EXTREME SPEED → COUNTER → TARGET SWITCH → EXTREME FAST.
Micro slow-motion is only used for selected near-miss moments. Combat never stops during the slow-motion moment.""");
    _set(dialogue, 'Natural location ambience, fast footsteps, realistic impacts, clothing movement and environmental reactions.');
    _set(negative, """cartoon, anime character, manga, 3D animation, CGI human, plastic skin, video-game character, face morphing, body morphing, identity change, hairstyle change, outfit change, extra limbs, deformed hands, distorted anatomy, supernatural power, magic, teleportation, floating, wire-fu, impossible physics, impossible jump, exaggerated flying, random punching, random kicking, stiff movement, robotic movement, slow combat, idle stance, combat reset, attackers waiting in line, duplicate criminals, spawning criminals, disappearing criminals, identity swapping, location change, camera teleportation, excessive camera shake, excessive motion blur, unreadable choreography, excessive blood, gore, graphic injury, victory pose, final freeze pose.""");
    combatType = '1 VS MANY';
    martialStyle = 'CUSTOM / FOLLOW INPUT';
    duration = '10 seconds';
    ratio = '16:9';
    language = 'English';
    opponentCount = 5;
    syncOpponents();
    final names = ['Criminal 1', 'Criminal 2', 'Criminal 3', 'Criminal 4', 'Criminal 5'];
    for (int i = 0; i < opponents.length && i < names.length; i++) opponents[i].text = names[i];
  }

  void _loadDjsjDefaults() {
    _set(title, 'Intan Permatasari vs Nguyen Thi Huong — Wushu Nanquan Tactical Exchange');
    _set(mainCharacter, 'Intan Permatasari (Wushu Nanquan – fast, fluid, agile, explosive)');
    _set(location, 'International Martial Arts Championship in Malaysia. Indoor international arena.');
    _set(surface, 'Blue competition mat. Official Competition Mat.');
    _set(combatDna, """Authentic Wushu Nanquan vs Authentic Wushu Nanquan.
Fast tactical exchange.
Focus on rhythm changes, angle changes, feints, timing, and clean scoring techniques.""");
    _set(shortChoreo, """0–2s:
Fight continues seamlessly.
Instead of attacking, Intan deliberately slows her movement.
She circles lightly while inviting Nguyen to attack first.
The audience becomes quiet, sensing a tactical battle.

2–4s:
Nguyen takes the opportunity.
She bursts forward with explosive Nanquan footwork.
Fast forward hand technique.
Immediate body-level Nanquan kick.
Intan narrowly avoids both attacks by making two short diagonal sidesteps.
No unnecessary blocking.

4–6s:
Seeing Nguyen overcommit slightly, Intan suddenly changes rhythm.
She slips to Nguyen's outside angle before firing a quick palm strike feint.
Nguyen instinctively raises her guard.
The crowd gasps.

6–8s:
Instead of following the feint, Intan instantly changes level into a deep Nanquan stance.
She rotates around Nguyen's lead side before delivering a powerful turning side kick.
The kick lands cleanly against Nguyen's guard while still connecting with her ribs.
Nguyen is forced backward one controlled step.

8–10s:
Nguyen immediately refuses to give ground.
She pivots outside Intan's center line before exploding with a skipping Nanquan kick followed by a spinning Nanquan kick.
The first kick brushes across Intan's shoulder.
The second is narrowly avoided as Intan leans backward by only a few centimeters.
The audience erupts.

10–12s:
SLOW MOTION.
Intan plants her lead foot firmly.
Without jumping excessively, she rotates smoothly into a beautiful spinning outside crescent kick.
The kick crashes into Nguyen's raised guard but still clips the side of her head.
Hair and uniform react naturally.
The arena roars.

12–13s:
Back to full speed.
Nguyen immediately answers by changing rhythm instead of attacking wildly.
She bounces twice, pauses for half a second, then suddenly explodes into a fast Nanquan back kick.
The kick lands firmly against Intan's abdomen.
A clear scoring technique.

13–14s:
Intan immediately circles away before re-entering from a different angle.
Spinning backfist feint → quick palm strike → jumping front kick.
The front kick lands solidly against Nguyen's guard while still pushing her backward.

14–15s:
Both athletes explode forward at exactly the same moment.
Intan launches another aggressive Nanquan entry.
Nguyen answers with a fast Nanquan combination.
Li Mei quickly sidesteps to maintain a clear view.
Scene CUT just before both techniques collide.
(NO STOP)
(NO POSE)
(NO FREEZE)""");
    _set(timing, """15 seconds total.
0–2s tactical invitation.
2–4s explosive Nguyen entry.
4–6s rhythm change and feint.
6–8s turning side kick.
8–10s skipping and spinning kicks.
10–12s slow-motion spinning outside crescent kick.
12–13s scoring back kick.
13–14s Intan re-entry combination.
14–15s simultaneous final exchange and cut before collision.
NO STOP. NO POSE. NO FREEZE.""");
    _set(camera, """Professional sports broadcast.
Smooth tracking.
Low tracking angle.
Focus on footwork and movement.
16:9.""");
    _set(lighting, 'Realistic indoor international arena lighting with consistent competition lighting and natural shadows.');
    _set(style, """Ultra realistic.
Natural skin.
Subtle halftone shading (color).
Real Indonesian human actors.
No cartoon.
No CGI.""");
    _set(dialogue, 'Heavy kick impacts. Fast footsteps. Crowd reactions become louder with every successful exchange. Natural arena ambience.');
    _set(negative, 'boxing ring, gloves, hand protectors, foot protectors, shin guards, body protector, exaggerated jump height, flying unrealistically, cartoon, anime, CGI, freeze ending, static pose');
    combatType = '1 VS 1';
    martialStyle = 'WUSHU NANQUAN';
    duration = '15 seconds';
    ratio = '16:9';
    language = 'English';
    opponentCount = 1;
    syncOpponents();
    opponents[0].text = 'Nguyen Thi Huong (Wushu Nanquan – strong, disciplined, focused)';
  }

  String _cast() {
    final lines = <String>[];
    lines.add('Image1 = ${_or(mainCharacter, 'Main Fighter')}');
    for (int i = 0; i < opponents.length; i++) {
      lines.add('Image${i + 2} = ${_or(opponents[i], 'Opponent ${i + 1}')}');
    }
    if (format == 'DUA JALAN SANG JUARA') {
      lines.add('Image${opponents.length + 2} = Li Mei (Official Referee)');
      lines.add('Image${opponents.length + 3} = Official Competition Mat');
    }
    return lines.join('\n');
  }

  String _styleGuidance() {
    final s = martialStyle.toLowerCase();
    if (s.contains('wushu')) return 'Use authentic Wushu movement language: fast fluid footwork, rhythm changes, angle changes, feints, clean explosive entries, controlled rotations and believable recovery.';
    if (s.contains('karate')) return 'Use authentic Karate movement language: disciplined stance, distance control, sharp entries, clean combinations, efficient pivots, controlled kicks and believable retraction.';
    if (s.contains('silat')) return 'Use authentic Pencak Silat movement language: low balanced footwork, angular entries, evasive body movement, sweeps, redirects and flowing transitions with realistic weight transfer.';
    if (s.contains('taekwondo')) return 'Use authentic Taekwondo movement language: dynamic footwork, distance management, fast kicks, chamber and retraction, angle changes and controlled landings.';
    if (s.contains('kung fu')) return 'Use authentic Kung Fu movement language: flowing combinations, directional changes, hand trapping, evasive steps, rotational attacks and grounded recovery.';
    return 'Develop the choreography from the user input while preserving the named martial-arts style, believable footwork, weight transfer, rhythm changes, angles, feints, attacks, evasions, counters and continuous transitions.';
  }

  String _environment() {
    final loc = _or(location, '');
    final surf = _or(surface, '');
    if (format == 'DUA JALAN SANG JUARA') {
      return """Environment:
$loc
$surf
Packed audience.
Large LED screen above the arena showing the live ${_or(mainCharacter, 'Main Fighter')} vs ${_or(opponents.first, 'Opponent')} match.
Keep the arena and competition mat consistent.""";
    }
    if (format == 'STREET FIGHT') {
      return """LOCATION:
$loc

Environment:
$surf
The environment provides believable obstacles, ground interaction and movement space.
Preserve spatial continuity throughout the entire fight.
No location changes.
No sudden environment transformation.""";
    }
    return """Environment:
$loc
$surf""";
  }

  String buildPrompt() {
    final promptTitle = _or(title, 'UNTITLED CINEMATIC ACTION SCENE');
    final cast = _cast();

    if (format == 'DUA JALAN SANG JUARA') {
      return """Hasilkan video: Create a hyper-realistic live-action cinematic video, real Indonesian human actors, natural imperfect skin, subtle halftone shading (color), no cartoon, no CGI.
Generate video:
image1 vs image2 + image3 + image4
Character Mapping:
$cast
Keep all character appearances consistent with the reference images.
${_environment()}
Fight Style:
${_or(combatDna, 'Authentic martial arts combat. Fast tactical exchange.')}
Camera:
${_or(camera, 'Professional sports broadcast. Smooth tracking. Low tracking angle. Focus on footwork and movement.')}
$ratio.
ACTION:
${_or(shortChoreo, 'Fight continues seamlessly with realistic tactical movement.')}
Visual Style:
${_or(style, 'Ultra realistic. Natural skin. Subtle halftone shading (color).')}
Audio:
${_or(dialogue, 'Natural arena ambience.')}
Negative Prompt:
${_or(negative, 'cartoon, anime, CGI, freeze ending, static pose')}""";
    }

    if (format == 'STREET FIGHT') {
      return """CREATE A 10-SECOND ULTRA-REALISTIC CINEMATIC MARTIAL ARTS ACTION VIDEO.

TITLE:
$promptTitle

FORMAT:
$duration, $ratio, 4K, photorealistic live-action.

REFERENCE:
Image1 = ${_or(mainCharacter, 'Kanza')}

CHARACTER:
Preserve ${_or(mainCharacter, 'Kanza')} from Image1 exactly:
same face, facial structure, hairstyle, skin tone, age appearance, body proportions, physique, outfit, shoes, accessories and overall identity.

Do not change her face, body, hairstyle or clothing.

No character morphing.

No outfit changes.

CAST:
$cast

${_environment()}

VISUAL STYLE:
${_or(style, 'Ultra-photorealistic live-action. Real human performers. Realistic anatomy. Realistic weight, gravity, contact and ground interaction. Modern Indonesian cinematic action film. Professional martial-arts stunt choreography. Natural directional motion blur. Cinematic depth of field. Realistic lighting and shadows. NO CGI-looking humans. NO anime characters. NO cartoon. NO 3D animation. NO supernatural powers. NO teleportation. NO floating. NO wire-fu. NO impossible jumps. NO exaggerated flying bodies.')}

COMBAT DNA:
${_or(combatDna, 'Extreme-speed anime-inspired martial arts translated into physically believable live-action movement.')}

FLOW:
ATTACK → PARRY → COUNTER → REPOSITION → EVADE → KICK → REPLANT → DIRECTION CHANGE → NEXT ATTACKER

Never reset into a fighting stance between attacks.
No idle moments.
No posing.
No unnecessary pauses.

Every attack must show:
preparation → execution → contact/near-miss → reaction → recovery → immediate transition.

MULTI-TARGET COMBAT:
All five criminals attack from different directions.
They must NOT wait in a straight line.
Kanza constantly changes angles and target priority.
Attackers move independently and react naturally to Kanza's position.
The five criminals must remain exactly five throughout the video.
No duplicates.
No spawning.
No disappearing.
No identity swapping.

ACTION / TIMING:
${_or(shortChoreo, 'Continuous realistic combat with logical attack, reaction, evasion, counter and repositioning.')}

EXTREME SPEED PHYSICS:
Every acceleration must follow:
FOOT PLANT → KNEE COMPRESSION → PHYSICAL PUSH-OFF → EXPLOSIVE ACCELERATION → SHORT DIRECTIONAL MOTION BLUR → DISTANCE CROSSING → HARD REPLANT → ATTACK → CONTACT / NEAR MISS → IMMEDIATE NEXT MOVEMENT.
No teleportation. The viewer must still perceive the physical transition between every movement. Use short directional speed blur only during explosive acceleration. Keep close-range hand and body actions readable.

SPEED RAMP LOCK:
EXTREME FAST → DANGEROUS NEAR MISS → 0.3 SECOND MICRO SLOW → DODGE → INSTANT SNAP BACK TO EXTREME SPEED → COUNTER → TARGET SWITCH → EXTREME FAST.
Micro slow-motion is only used for selected near-miss moments.
Combat never stops during the slow-motion moment.

CAMERA STYLE:
${_or(camera, 'Replace the previous close handheld camera with a more cinematic reactive action-film camera. The camera remains physically operated and always follows the action, but with smoother controlled movement.')}

TIMING:
${_or(timing, '$duration total.')}

CAMERA RULE:
The character moves first.
The camera reacts second.
Camera reaction should be approximately 0.1–0.2 seconds behind the action.
Use smooth tracking, controlled lateral movement, short orbit, brief low angle, brief elevated perspective and smooth pullback.
Avoid excessive handheld shake.
No camera teleportation.
No impossible camera movement.
No random cuts.
No sudden location changes.
Maintain spatial continuity at all times.

PRIORITY:
1. Physical continuity
2. Choreography quality
3. Character identity
4. Realistic human movement
5. Camera cinematic quality
6. Extreme speed

The choreography must remain dense and continuous.
Kanza must look like a highly trained professional martial artist, not a normal person randomly fighting.

NEGATIVE PROMPT:
${_or(negative, 'cartoon, anime character, manga, 3D animation, CGI human, plastic skin, video-game character, face morphing, body morphing, identity change, hairstyle change, outfit change, extra limbs, deformed hands, distorted anatomy, supernatural power, magic, teleportation, floating, wire-fu, impossible physics, impossible jump, exaggerated flying, random punching, random kicking, stiff movement, robotic movement, slow combat, idle stance, combat reset, attackers waiting in line, duplicate criminals, spawning criminals, disappearing criminals, identity swapping, location change, camera teleportation, excessive camera shake, excessive motion blur, unreadable choreography, excessive blood, gore, graphic injury, victory pose, final freeze pose.')}

AUDIO:
${_or(dialogue, 'Natural location ambience, fast footsteps, realistic impacts, clothing movement and environmental reactions.')}

OUTPUT LANGUAGE:
$language""";
    }

    return """Create a hyper-realistic live-action cinematic video.

TITLE:
$promptTitle

FORMAT:
$duration, $ratio.

REFERENCE / CAST:
$cast
Keep all character appearances consistent with the reference images.

ENVIRONMENT:
${_environment()}

FIGHT STYLE:
${_or(martialStyle == 'CUSTOM / FOLLOW INPUT' ? combatDna : TextEditingController(text: martialStyle), 'Authentic martial arts combat.')}

ACTION / CHOREOGRAPHY:
${_or(shortChoreo, '')}

TIMING:
${_or(timing, '')}

CAMERA:
${_or(camera, '')}

LIGHTING:
${_or(lighting, '')}

VISUAL STYLE:
${_or(style, '')}

DIALOGUE / AUDIO:
${_or(dialogue, '')}

NEGATIVE PROMPT:
${_or(negative, '')}

OUTPUT LANGUAGE:
$language""";
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
            const Text('Select a master format, edit the defaults, then generate.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 22),
            field('Project / Title', title, maxLines: 2),
            section('FORMAT / PROMPT ENGINE'),
            DropdownButtonFormField<String>(
              value: format,
              decoration: const InputDecoration(labelText: 'Format'),
              items: ['STREET FIGHT', 'DUA JALAN SANG JUARA', 'CUSTOM']
                  .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                  .toList(),
              onChanged: (v) => applyFormatDefaults(v ?? format),
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
            field('Main Character', mainCharacter, maxLines: 2),
            for (int i = 0; i < opponentCount; i++) field('Opponent ${i + 1}', opponents[i], maxLines: 2),
            section('SCENE'),
            field('Location / Venue', location, maxLines: 4),
            field('Competition Mat / Surface', surface, maxLines: 4),
            field('Combat DNA', combatDna, maxLines: 12),
            section('KOREO ENGINE'),
            field('Koreografi / ACTION', shortChoreo, maxLines: 18),
            field('Timing', timing, maxLines: 10),
            field('Camera', camera, maxLines: 12),
            section('CINEMATIC CONTROL'),
            field('Lighting', lighting, maxLines: 4),
            field('Visual Style', style, maxLines: 10),
            field('Dialogue / Audio', dialogue, maxLines: 5),
            field('Negative Prompt', negative, maxLines: 8),
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
