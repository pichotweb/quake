class GameType < ApplicationRecord

  # font https://ioquake3.org/help/sys-admin-guide/

  DEATHMATCH = 0
  ONEONONE = 1
  SINGLEPLAYERDEATHMATCH = 2
  TEAMDEATHMATCH = 3
  CAPTURETHEFLAG = 4

  def self.names
    {
      DEATHMATCH => 'Deathmatch',
      ONEONONE => 'One on One (Tournament)',
      SINGLEPLAYERDEATHMATCH => 'Single Player Deatchmatch',
      TEAMDEATHMATCH => 'Team DeathMatch',
      CAPTURETHEFLAG => 'Capture the flag',
    } 
  end
  
  def self.icons
    {
      DEATHMATCH => 'fa-skull',
      ONEONONE => 'fa-person-harassing',
      SINGLEPLAYERDEATHMATCH => 'fa-user',
      TEAMDEATHMATCH => 'fa-people-group',
      CAPTURETHEFLAG => 'fa-flag',
    }
  end

  def self.colors
    {
      DEATHMATCH => '#00A000',
      ONEONONE => '#1e6618',
      SINGLEPLAYERDEATHMATCH => '#5C5A99',
      TEAMDEATHMATCH => '#D2691E',
      CAPTURETHEFLAG => '#D2691E'  
    }
  end
  
end
