class GameEventType < ApplicationRecord

  INITGAME = 0
  CLIENTBEGIN = 1
  CLIENTCONNECT = 2
  CLIENTUSERINFOCHANGED = 3
  ITEM = 4
  KILL = 5
  CLIENTDISCONNECT = 6
  EXIT = 7
  SHUTDOWNGAME = 8

  def self.names
    {
      INITGAME => 'InitGame',
      CLIENTBEGIN => 'ClientBegin',
      CLIENTCONNECT => 'ClientConnect',
      CLIENTUSERINFOCHANGED => 'ClientUserinfoChanged',
      ITEM => 'Item',
      KILL => 'Kill',
      CLIENTDISCONNECT => 'ClientDisconnect',
      EXIT => 'Exit',
      SHUTDOWNGAME => 'ShutdownGame'
    } 
  end
  
end
