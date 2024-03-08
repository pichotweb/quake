class GameEventType < ApplicationRecord

  INITGAME = 0
  EXIT = 1
  CLIENTCONNECT = 2
  CLIENTUSERINFOCHANGED = 3
  CLIENTBEGIN = 4
  SHUTDOWNGAME = 5
  ITEM = 6
  KILL = 7
  CLIENTDISCONNECT = 8

  def self.names
    {
      INITGAME => 'InitGame',
      EXIT => 'Exit',
      CLIENTCONNECT => 'ClientConnect',
      CLIENTUSERINFOCHANGED => 'ClientUserinfoChanged',
      CLIENTBEGIN => 'ClientBegin',
      SHUTDOWNGAME => 'ShutdownGame',
      ITEM => 'Item',
      KILL => 'Kill',
      CLIENTDISCONNECT => 'ClientDisconnect'
    } 
  end
  
end
