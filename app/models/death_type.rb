class DeathType
  MOD_UNKNOWN = 0
  MOD_SHOTGUN = 1
  MOD_GAUNTLET = 2
  MOD_MACHINEGUN = 3
  MOD_GRENADE = 4
  MOD_GRENADE_SPLASH = 5
  MOD_ROCKET = 6
  MOD_ROCKET_SPLASH = 7
  MOD_PLASMA = 8
  MOD_PLASMA_SPLASH = 9
  MOD_RAILGUN = 10
  MOD_LIGHTNING = 11
  MOD_BFG = 12
  MOD_BFG_SPLASH = 13
  MOD_WATER = 14
  MOD_SLIME = 15
  MOD_LAVA = 16
  MOD_CRUSH = 17
  MOD_TELEFRAG = 18
  MOD_FALLING = 19
  MOD_SUICIDE = 20
  MOD_TARGET_LASER = 21
  MOD_TRIGGER_HURT = 22

  # Missionpack
  MOD_NAIL = 23
  MOD_CHAINGUN = 24
  MOD_PROXIMITY_MINE = 25
  MOD_KAMIKAZE = 26
  MOD_JUICED = 27

  MOD_GRAPPLE = 28

  def self.names
    {
      MOD_UNKNOWN => 'Unknown',
      MOD_SHOTGUN => 'Shotgun',
      MOD_GAUNTLET => 'Gauntlet',
      MOD_MACHINEGUN => 'Machine Gun',
      MOD_GRENADE => 'Grenade',
      MOD_GRENADE_SPLASH => 'Grenade Splash',
      MOD_ROCKET => 'Rocket',
      MOD_ROCKET_SPLASH => 'Rocket Splash',
      MOD_PLASMA => 'Plasma',
      MOD_PLASMA_SPLASH => 'Plasma Splash',
      MOD_RAILGUN => 'Railgun',
      MOD_LIGHTNING => 'Lightning',
      MOD_BFG => 'BFG',
      MOD_BFG_SPLASH => 'BFG Splash',
      MOD_WATER => 'Water',
      MOD_SLIME => 'Slime',
      MOD_LAVA => 'Lava',
      MOD_CRUSH => 'Crush',
      MOD_TELEFRAG => 'Telefrag',
      MOD_FALLING => 'Falling',
      MOD_SUICIDE => 'Suicide',
      MOD_TARGET_LASER => 'Target Laser',
      MOD_TRIGGER_HURT => 'Trigger Hurt',
      MOD_NAIL => 'Nail',
      MOD_CHAINGUN => 'Chaingun',
      MOD_PROXIMITY_MINE => 'Proximity Mine',
      MOD_KAMIKAZE => 'Kamikaze',
      MOD_JUICED => 'Juiced',
      MOD_GRAPPLE => 'Grapple'
    }
  end
end
