require 'test/unit'
require 'eve_killmail_parser'
class EveKillmailParserTest < Test::Unit::TestCase
  
  def setup
    mail_to_parse = s = <<end
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
end
    @km = Eve::Killmail::Parser.new(mail_to_parse)
  end
  def test_load
    assert_instance_of Eve::Killmail::Parser, @km
  end
  def test_victim
    assert_equal 'Ix Forres', @km.victim.name
    assert_equal 'Vanguard Frontiers', @km.victim.corporation
    assert_equal 'Imperial Republic Of the North', @km.victim.alliance
    assert_equal 'NONE', @km.victim.faction
    assert_equal 'Scorpion', @km.victim.destroyed
    assert_equal '2R-CRW', @km.victim.system
    assert_equal 0.0, @km.victim.security
    assert_equal 20029, @km.victim.damage_taken
  end
  def test_attackers
    assert_equal 'TheWino', @km.attackers[0].name
    assert_equal 5.0, @km.attackers[0].security
    assert_equal 'Black Nova Corp', @km.attackers[0].corporation
    assert_equal 'Band of Brothers', @km.attackers[0].alliance
    assert_equal 'NONE', @km.attackers[0].faction
    assert_equal 'Drake', @km.attackers[0].ship
    assert_equal 'Caldari Navy Scourge Heavy Missile', @km.attackers[0].weapon
    assert_equal 3368, @km.attackers[0].damage_done
  end
  def test_dropped
    assert_equal 'Signal Distortion Amplifier II', @km.dropped[0].name
    assert_equal 'Cruise Missile Launcher I', @km.dropped[4].name
    assert_equal 3, @km.dropped[4].quantity
    assert_equal true, @km.dropped[10].cargo
    assert_equal true, @km.dropped[11].drone
  end
  def test_destroyed
    assert_equal 'Sensor Booster II', @km.destroyed[1].name
    assert_equal "Signal Distortion Amplifier II", @km.destroyed[0].name
    assert_equal 2, @km.destroyed[0].quantity
    assert_equal true, @km.destroyed[4].cargo
    assert_equal true, @km.destroyed[6].drone
  end
end
