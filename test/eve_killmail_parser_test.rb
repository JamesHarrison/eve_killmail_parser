require 'test/unit'
require 'eve_killmail_parser'
class EveKillmailParserTest < Test::Unit::TestCase
  
  def setup
    pod_mail = "2008.11.03 05:03:00

Victim: Pinky Panther
Corp: Southern Cross Incorporated
Alliance: Southern Cross Alliance
Faction: NONE
Destroyed: Capsule
System: LXQ2-T
Security: 0.0
Damage Taken: 451

Involved parties:

Name: iaitite (laid the final blow)
Security: 0.2
Corp: Vanguard Frontiers
Alliance: Violent-Tendencies
Faction: NONE
Ship: Nemesis
Weapon: Caldari Navy Devastator Cruise Missile
Damage Done: 278

Name: Xirxo
Security: 2.3
Corp: Vanguard Frontiers
Alliance: Violent-Tendencies
Faction: NONE
Ship: Rapier
Weapon: 650mm Artillery Cannon II
Damage Done: 173

Name: Freya Alvar
Security: 2.2
Corp: Vanguard Frontiers
Alliance: Violent-Tendencies
Faction: NONE
Ship: Manticore
Weapon: 'Arbalest' Cruise Launcher I
Damage Done: 0"
    nonplayer_attacking_mail = "
    2008.11.17 15:46

Victim: Vicateur
Corp: ThunderCrash MC
Alliance: Space Technologies
Faction: NONE
Destroyed: Rokh
System: C4C-Z4
Security: 0.0
Damage Taken: 29485

Involved parties:

Name: Medium Railgun Battery / Holiday On ICE
Damage Done: 14149

Name: Zostera (laid the final blow)
Security: 3.1
Corp: Ascent of Ages
Alliance: Sc0rched Earth
Faction: NONE
Ship: Hound
Weapon: Devastator Cruise Missile
Damage Done: 6695

Name: ST0NE MONKEY
Security: 4.0
Corp: Ascent of Ages
Alliance: Sc0rched Earth
Faction: NONE
Ship: Nemesis
Weapon: Caldari Navy Cataclysm Cruise Missile
Damage Done: 4852

Name: eRa5oR
Security: 2.4
Corp: BROWBEAT
Alliance: Sc0rched Earth
Faction: NONE
Ship: Manticore
Weapon: Caldari Navy Wrath Cruise Missile
Damage Done: 2405

Name: SovietGuard
Security: 1.8
Corp: BROWBEAT
Alliance: Sc0rched Earth
Faction: NONE
Ship: Crow
Weapon: Bloodclaw Light Missile
Damage Done: 1384

Name: xXxSatsujinxXx
Security: 5.0
Corp: Ascent of Ages
Alliance: Sc0rched Earth
Faction: NONE
Ship: Ishtar
Weapon: Heavy Ion Blaster II
Damage Done: 0

Name: Chiz
Security: 4.2
Corp: Vanguard Frontiers
Alliance: None
Faction: NONE
Ship: Falcon
Weapon: ECM - Spatial Destabilizer II
Damage Done: 0

Name: topman324
Security: 5.0
Corp: Ascent of Ages
Alliance: Sc0rched Earth
Faction: NONE
Ship: Arazu
Weapon: Phased Muon Sensor Disruptor I
Damage Done: 0

Name: paulcdb
Security: 5.0
Corp: Ascent of Ages
Alliance: Sc0rched Earth
Faction: NONE
Ship: Falcon
Weapon: ECM - Spatial Destabilizer II
Damage Done: 0


Destroyed items:

Prototype Cloaking Device I
425mm 'Scout' I Accelerator Cannon
425mm 'Scout' I Accelerator Cannon
425mm 'Scout' I Accelerator Cannon
Iridium Charge L, Qty: 120
Beta Reactor Control: Diagnostic System I
Beta Reactor Control: Diagnostic System I
Magnetic Field Stabilizer II
Targeting Range, Qty: 3 (Cargo)
Capacitor Control Circuit I, Qty: 3
Light Armor Maintenance Bot I, Qty: 2 (Drone Bay)
Hobgoblin I, Qty: 2 (Drone Bay)

Dropped items:

425mm 'Scout' I Accelerator Cannon
425mm 'Scout' I Accelerator Cannon
425mm 'Scout' I Accelerator Cannon
425mm 'Scout' I Accelerator Cannon
Iridium Charge L, Qty: 160
Cap Recharger II
Scan Resolution
Scan Resolution
Scan Resolution
Scan Resolution
Sensor Booster II
Sensor Booster II
Sensor Booster II
Sensor Booster II
Sensor Booster II
Magnetic Field Stabilizer II
Magnetic Field Stabilizer II
Iridium Charge L, Qty: 4625 (Cargo)
Light Armor Maintenance Bot I, Qty: 3 (Drone Bay)
Hobgoblin I, Qty: 3 (Drone Bay)
"
    normal_mail = "
2008.07.23 00:47:00

Victim: Ix Forres
Corp: Vanguard Frontiers
Alliance: Imperial Republic Of the North
Faction: NONE
Destroyed: Scorpion
System: 2R-CRW
Security: 0.0
Damage Taken: 20029

Involved parties:

Name: TheWino (laid the final blow)
Security: 5.0
Corp: Black Nova Corp
Alliance: Band of Brothers
Faction: NONE
Ship: Drake
Weapon: Caldari Navy Scourge Heavy Missile
Damage Done: 3368

Name: Bux Naked
Security: 5.0
Corp: Reikoku
Alliance: Band of Brothers
Faction: NONE
Ship: Vagabond
Weapon: Vagabond
Damage Done: 2219

Destroyed items:

Signal Distortion Amplifier II, Qty: 2
Sensor Booster II
ECM - Multispectral Jammer II
Cruise Missile Launcher I
Devastator Cruise Missile, Qty: 776 (Cargo)
ECM - Spatial Destabilizer II
Hornet II, Qty: 5 (Drone Bay)
Heavy Energy Neutralizer I
Scan Resolution
Devastator Cruise Missile, Qty: 20
ECM - Phase Inverter II

Dropped items:

Signal Distortion Amplifier II
Nanofiber Internal Structure I
Sensor Booster II
ECM - Ion Field Projector II
Cruise Missile Launcher I, Qty: 3
ECM - White Noise Generator II
100MN MicroWarpdrive II
Heavy Energy Neutralizer I
Scan Resolution
Devastator Cruise Missile, Qty: 60
Mobile Small Warp Disruptor I (Cargo)
Vespa EC-600, Qty: 5 (Drone Bay)
"
pos_mail = "
2008.05.12 15:52:00

Corp: Celestial Apocalypse
Alliance: Insurgency
Faction: NONE
Destroyed: Caldari Control Tower Small
Moon: 0P9Z-I V - Moon 16
System: 0P9Z-I
Security: 0.0
Damage Taken: 8439716

Involved parties:

Name: Zulimu
Security: 5.0
Corp: Oberon Incorporated
Alliance: Morsus Mihi
Faction: NONE
Ship: Maelstrom
Weapon: Maelstrom
Damage Done: 603244

Name: BROOL
Security: 3.4
Corp: hirr
Alliance: Morsus Mihi
Faction: NONE
Ship: Megathron
Weapon: Bouncer I
Damage Done: 517985

Name: LiMu Bai
Security: 5.0
Corp: Free-Space-Ranger
Alliance: Morsus Mihi
Faction: NONE
Ship: Megathron
Weapon: Megathron
Damage Done: 412645

Name: Gaah Wren
Security: 2.5
Corp: Roving Guns Inc.
Alliance: RAZOR Alliance
Faction: NONE
Ship: Apocalypse
Weapon: Bouncer I
Damage Done: 390015

Name: Mizuki
Security: 5.0
Corp: The Forsakened Companions
Alliance: Pure.
Faction: NONE
Ship: Apocalypse
Weapon: Apocalypse
Damage Done: 344876

Name: David Devant
Security: 5.0
Corp: Solarflare Heavy Industries
Alliance: Pure.
Faction: NONE
Ship: Megathron
Weapon: Bouncer I
Damage Done: 337711

Name: George Charleston
Security: 5.0
Corp: PsyCorp
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Raven
Weapon: Paradise Cruise Missile
Damage Done: 327702

Name: Rotten one
Security: 5.0
Corp: Old Farts
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Raven
Weapon: Garde I
Damage Done: 326059

Name: Kithron (laid the final blow)
Security: 4.4
Corp: Darklite inc
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Megathron
Weapon: 425mm Railgun II
Damage Done: 293341

Name: Frozen Buffalo
Security: 5.0
Corp: Free-Space-Ranger
Alliance: Morsus Mihi
Faction: NONE
Ship: Megathron
Weapon: 425mm Railgun II
Damage Done: 288284

Name: Kalidri Ngyuen
Security: 4.1
Corp: Dragons United
Alliance: Pure.
Faction: NONE
Ship: Apocalypse
Weapon: Apocalypse
Damage Done: 286821

Name: Yakumo Smith
Security: 5.1
Corp: The Forsakened Companions
Alliance: Pure.
Faction: NONE
Ship: Apocalypse
Weapon: Apocalypse
Damage Done: 281946

Name: DarkNeo
Security: 5.0
Corp: GREY COUNCIL
Alliance: Hydra Alliance
Faction: NONE
Ship: Apocalypse
Weapon: Apocalypse
Damage Done: 280141

Name: Asoka Remko
Security: 5.0
Corp: Quantum Industries
Alliance: RAZOR Alliance
Faction: NONE
Ship: Raven
Weapon: Wrath Cruise Missile
Damage Done: 265616

Name: Matt Stoner
Security: 3.7
Corp: Synergy.
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Megathron
Weapon: Megathron
Damage Done: 253069

Name: Nexria
Security: 0.6
Corp: Minds Of Space
Alliance: Hydra Alliance
Faction: NONE
Ship: Raven
Weapon: Wrath Cruise Missile
Damage Done: 234868

Name: Balthamael
Security: 5.0
Corp: hirr
Alliance: Morsus Mihi
Faction: NONE
Ship: Megathron
Weapon: Megathron
Damage Done: 228195

Name: Takeshi Nuwen
Security: 5.0
Corp: The X-Trading Company
Alliance: Mostly  Harmless
Faction: NONE
Ship: Raven
Weapon: 'Arbalest' Siege Missile Launcher
Damage Done: 226010

Name: Kena tomBrok
Security: 5.0
Corp: Marquie-X Corp
Alliance: Majesta Empire
Faction: NONE
Ship: Tempest
Weapon: Tempest
Damage Done: 221517

Name: La Valette
Security: 0.1
Corp: KAOS.
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Megathron
Weapon: Warden I
Damage Done: 185614

Name: BladeMos
Security: 4.6
Corp: KAOS.
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Rokh
Weapon: Rokh
Damage Done: 175907

Name: kill0rbunny
Security: 0.7
Corp: Jagdkommando
Alliance: RAZOR Alliance
Faction: NONE
Ship: Megathron
Weapon: Megathron
Damage Done: 175703

Name: Delrin Blade
Security: 4.8
Corp: Oberon Incorporated
Alliance: Morsus Mihi
Faction: NONE
Ship: Tempest
Weapon: Tempest
Damage Done: 175263

Name: mrwinky
Security: 5.0
Corp: Madhatters Inc.
Alliance: Pure.
Faction: NONE
Ship: Unknown
Weapon: 1400mm Howitzer Artillery II
Damage Done: 174914

Name: Granmethedon III
Security: -0.3
Corp: The Wild Hunt
Alliance: Pure.
Faction: NONE
Ship: Tempest
Weapon: 1400mm Prototype I Siege Cannon
Damage Done: 162799

Name: Blowfly
Security: 1.1
Corp: Free-Space-Ranger
Alliance: Morsus Mihi
Faction: NONE
Ship: Raven
Weapon: Cataclysm Cruise Missile
Damage Done: 160492

Name: Floryan Rotbart
Security: 2.6
Corp: Free-Space-Ranger
Alliance: Morsus Mihi
Faction: NONE
Ship: Megathron
Weapon: Megathron
Damage Done: 136241

Name: Kcyx
Security: 1.3
Corp: Synergy.
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Megathron
Weapon: Megathron
Damage Done: 131208

Name: Meerko
Security: 5.0
Corp: The Arrow Project
Alliance: Morsus Mihi
Faction: NONE
Ship: Rokh
Weapon: Rokh
Damage Done: 128942

Name: VictorSteiner
Security: 3.6
Corp: Free-Space-Ranger
Alliance: Morsus Mihi
Faction: NONE
Ship: Scorpion
Weapon: BZ-5 Neutralizing Spatial Destabilizer ECM
Damage Done: 127428

Name: Madrillian
Security: 5.0
Corp: Decadence.
Alliance: RAZOR Alliance
Faction: NONE
Ship: Scorpion
Weapon: Devastator Cruise Missile
Damage Done: 120585

Name: SpAcK
Security: 5.1
Corp: The X-Trading Company
Alliance: Mostly  Harmless
Faction: NONE
Ship: Rokh
Weapon: Rokh
Damage Done: 117040

Name: Lu Ziffer
Security: 4.9
Corp: Jelly Baby Corporation
Alliance: Majesta Empire
Faction: NONE
Ship: Rokh
Weapon: Rokh
Damage Done: 103357

Name: Potomir Alexejev
Security: 5.6
Corp: The X-Trading Company
Alliance: Mostly  Harmless
Faction: NONE
Ship: Megathron
Weapon: Megathron
Damage Done: 80530

Name: Codin Plaks
Security: 5.0
Corp: Dawn of a new Empire
Alliance: Pure.
Faction: NONE
Ship: Unknown
Weapon: 425mm Railgun II
Damage Done: 62900

Name: shefupity
Security: 4.0
Corp: InterGalactic Corp.
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Deimos
Weapon: Deimos
Damage Done: 29882

Name: Minrnitir
Security: 3.9
Corp: GREY COUNCIL
Alliance: Hydra Alliance
Faction: NONE
Ship: Nemesis
Weapon: Cataclysm Cruise Missile
Damage Done: 26487

Name: Lady Punjab
Security: 0.4
Corp: Madhatters Inc.
Alliance: Pure.
Faction: NONE
Ship: Apocalypse
Weapon: Apocalypse
Damage Done: 16634

Name: Atric
Security: 4.6
Corp: The Wild Hunt
Alliance: Pure.
Faction: NONE
Ship: Apocalypse
Weapon: Apocalypse
Damage Done: 12684

Name: alpha seno
Security: 3.9
Corp: E X O D U S
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Rapier
Weapon: 720mm Howitzer Artillery II
Damage Done: 8275

Name: Own Age
Security: 0.5
Corp: Bladerunners
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Ares
Weapon: 150mm Railgun II
Damage Done: 4846

Name: gosship
Security: 0.0
Corp: InterGalactic Corp.
Alliance: Imperial Republic Of the North
Faction: NONE
Ship: Unknown
Weapon: Upgraded 'Limos' Standard Missile Bay I
Damage Done: 1940
"
warp_bubble_mail = "
2008.09.25 01:09:00

Victim: barnabis collins
Corp: Federal Navy Academy
Alliance: NONE
Faction: NONE
Destroyed: Bantam
System: PF-346
Security: 0.0
Damage Taken: 514

Involved parties:

Name: Mistralis
Security: 5.0
Corp: Free Galactic Enterprises
Alliance: Violent-Tendencies
Faction: NONE
Ship: Crow
Weapon: Crow
Damage Done: 364

Name: iaitite (laid the final blow)
Security: 0.6
Corp: Vanguard Frontiers
Alliance: Violent-Tendencies
Faction: NONE
Ship: Nemesis
Weapon: Caldari Navy Devastator Cruise Missile
Damage Done: 150

Name: Mobile Large Warp Disruptor I / Free Galactic Enterprises
Damage Done: 0

Name: bodycollecter
Security: 2.1
Corp: Free Galactic Enterprises
Alliance: Violent-Tendencies
Faction: NONE
Ship: Manticore
Weapon: Cruise Missile Launcher II
Damage Done: 0

Name: capt Goober
Security: 2.9
Corp: Trioptimum
Alliance: Violent-Tendencies
Faction: NONE
Ship: Purifier
Weapon: Parallel Weapon Navigation Transmitter
Damage Done: 0

Name: Abis Cann
Security: 3.6
Corp: Gemini Sun
Alliance: Violent-Tendencies
Faction: NONE
Ship: Manticore
Weapon: XT-9000 Cruise Launcher
Damage Done: 0

Name: Achura Dari
Security: 0.3
Corp: Vanguard Frontiers
Alliance: Violent-Tendencies
Faction: NONE
Ship: Falcon
Weapon: 'Hypnos' Multispectral ECM I
Damage Done: 0

Destroyed items:

Radio S (Cargo)

Dropped items:

Basic Miner
Ship Scanner I
Expanded Cargohold I
Light Neutron Blaster I  "
    @normal_km = Eve::Killmail::Parser.new(normal_mail)
    @nonplayer_attacking_km = Eve::Killmail::Parser.new(nonplayer_attacking_mail)
    @pos_km = Eve::Killmail::Parser.new(pos_mail)
    @warp_bubble_km = Eve::Killmail::Parser.new(warp_bubble_mail)
    @pod_km = Eve::Killmail::Parser.new(pod_mail)
  end
  def test_load_normal
    assert_instance_of Eve::Killmail::Parser, @normal_km
  end
  def test_load_nonplayer_attacking
    assert_instance_of Eve::Killmail::Parser, @nonplayer_attacking_km
  end
  def test_load_warp_bubble
    assert_instance_of Eve::Killmail::Parser, @warp_bubble_km
  end
  def test_load_pos
    assert_instance_of Eve::Killmail::Parser, @pos_km
  end
  def test_load_pod
    assert_instance_of Eve::Killmail::Parser, @pod_km
  end
  
  def test_victim
    assert_equal 'Ix Forres', @normal_km.victim.name
    assert_equal 'Vanguard Frontiers', @normal_km.victim.corporation
    assert_equal 'Imperial Republic Of the North', @normal_km.victim.alliance
    assert_equal 'NONE', @normal_km.victim.faction
    assert_equal 'Scorpion', @normal_km.victim.destroyed
    assert_equal '2R-CRW', @normal_km.victim.system
    assert_equal 0.0, @normal_km.victim.security
    assert_equal 20029, @normal_km.victim.damage_taken
  end
  def test_normal_attackers
    assert_equal 'TheWino', @normal_km.attackers[0].name
    assert_equal 5.0, @normal_km.attackers[0].security
    assert_equal 'Black Nova Corp', @normal_km.attackers[0].corporation
    assert_equal 'Band of Brothers', @normal_km.attackers[0].alliance
    assert_equal 'NONE', @normal_km.attackers[0].faction
    assert_equal 'Drake', @normal_km.attackers[0].ship
    assert_equal 'Caldari Navy Scourge Heavy Missile', @normal_km.attackers[0].weapon
    assert_equal 3368, @normal_km.attackers[0].damage_done
    assert_equal false, @normal_km.attackers[0].object
  end
  def test_dropped
    assert_equal 'Signal Distortion Amplifier II', @normal_km.dropped[0].name
    assert_equal 'Cruise Missile Launcher I', @normal_km.dropped[4].name
    assert_equal 3, @normal_km.dropped[4].quantity
    assert_equal true, @normal_km.dropped[10].cargo
    assert_equal true, @normal_km.dropped[11].drone
  end
  def test_destroyed
    assert_equal 'Sensor Booster II', @normal_km.destroyed[1].name
    assert_equal "Signal Distortion Amplifier II", @normal_km.destroyed[0].name
    assert_equal 2, @normal_km.destroyed[0].quantity
    assert_equal true, @normal_km.destroyed[4].cargo
    assert_equal true, @normal_km.destroyed[6].drone
  end
  def test_nonplayer_attacker
    assert_equal 'Medium Railgun Battery', @nonplayer_attacking_km.attackers[0].weapon
    assert_equal 'Holiday On ICE', @nonplayer_attacking_km.attackers[0].corporation
    assert_equal true, @nonplayer_attacking_km.attackers[0].object
    assert_equal 9, @nonplayer_attacking_km.attackers.length
  end
  def test_nonplayer_attacking_attackers
    assert_equal 'Zostera', @nonplayer_attacking_km.attackers[1].name
    assert_equal 3.1, @nonplayer_attacking_km.attackers[1].security
    assert_equal 'Ascent of Ages', @nonplayer_attacking_km.attackers[1].corporation
    assert_equal 'Sc0rched Earth', @nonplayer_attacking_km.attackers[1].alliance
    assert_equal 'NONE', @nonplayer_attacking_km.attackers[1].faction
    assert_equal 'Hound', @nonplayer_attacking_km.attackers[1].ship
    assert_equal 'Devastator Cruise Missile', @nonplayer_attacking_km.attackers[1].weapon
    assert_equal 6695, @nonplayer_attacking_km.attackers[1].damage_done
    assert_equal false, @nonplayer_attacking_km.attackers[1].object
    assert_equal true, @nonplayer_attacking_km.attackers[1].final_blow
  end
  def test_warp_bubble_attacker
    assert_equal 'Mobile Large Warp Disruptor I', @warp_bubble_km.attackers[2].weapon
    assert_equal 'Free Galactic Enterprises', @warp_bubble_km.attackers[2].corporation
    assert_equal true, @warp_bubble_km.attackers[2].object
    assert_equal 7, @warp_bubble_km.attackers.length
  end

  def test_warp_bubble_attacker_attackers
    assert_equal 'Mistralis', @warp_bubble_km.attackers[0].name
    assert_equal 5.0, @warp_bubble_km.attackers[0].security
    assert_equal 'Free Galactic Enterprises', @warp_bubble_km.attackers[0].corporation
    assert_equal 'Violent-Tendencies', @warp_bubble_km.attackers[0].alliance
    assert_equal 'NONE', @warp_bubble_km.attackers[0].faction
    assert_equal 'Crow', @warp_bubble_km.attackers[0].ship
    assert_equal 'Crow', @warp_bubble_km.attackers[0].weapon
    assert_equal 364, @warp_bubble_km.attackers[0].damage_done
    assert_equal false, @warp_bubble_km.attackers[0].object
  end
  
  def test_pod_attackers
    assert_equal 'iaitite', @pod_km.attackers[0].name
    assert_equal 0.2, @pod_km.attackers[0].security
    assert_equal 'Vanguard Frontiers', @pod_km.attackers[0].corporation
    assert_equal 'Violent-Tendencies', @pod_km.attackers[0].alliance
    assert_equal 'NONE', @pod_km.attackers[0].faction
    assert_equal 'Nemesis', @pod_km.attackers[0].ship
    assert_equal 'Caldari Navy Devastator Cruise Missile', @pod_km.attackers[0].weapon
    assert_equal 278, @pod_km.attackers[0].damage_done
    assert_equal false, @pod_km.attackers[0].object
  end
  
  def test_pod_victim
    assert_equal 'Pinky Panther', @pod_km.victim.name
    assert_equal 'Southern Cross Incorporated', @pod_km.victim.corporation
    assert_equal 'Southern Cross Alliance', @pod_km.victim.alliance
    assert_equal 'NONE', @pod_km.victim.faction
    assert_equal 'Capsule', @pod_km.victim.destroyed
    assert_equal 'LXQ2-T', @pod_km.victim.system
    assert_equal 0.0, @pod_km.victim.security
    assert_equal 451, @pod_km.victim.damage_taken
  end
  
end
