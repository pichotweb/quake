class GameEventType < ApplicationRecord

  INITGAME = 1
  CLIENTBEGIN = 2
  CLIENTCONNECT = 3
  CLIENTUSERINFOCHANGED = 4
  ITEM = 5
  KILL = 6
  CLIENTDISCONNECT = 7
  EXIT = 8
  SHUTDOWNGAME = 9
  CHAT_INTERACTION = 10

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
      SHUTDOWNGAME => 'ShutdownGame',
      CHAT_INTERACTION => 'ChatInteraction'
    } 
  end
  
  def self.icons
    {
      INITGAME => 'fa-link',
      CLIENTBEGIN => 'fa-user-check',
      CLIENTCONNECT => 'fa-user-plus',
      CLIENTUSERINFOCHANGED => 'fa-tag',
      ITEM => 'fa-star',
      KILL => 'fa-skull',
      CLIENTDISCONNECT => 'fa-user-slash',
      EXIT => 'fa-server',
      SHUTDOWNGAME => 'fa-server',
      CHAT_INTERACTION => 'fa-comments'
    }
  end

  def self.colors
    {
      INITGAME => '#00A000',
      CLIENTBEGIN => '#1e6618',
      CLIENTCONNECT => '#5C5A99',
      CLIENTUSERINFOCHANGED => '#D2691E',
      ITEM => '#8B8B00',
      KILL => '#D95353',
      CLIENTDISCONNECT => '#D98797',
      EXIT => '#c4291b',
      SHUTDOWNGAME => '#A9A9A9',
      CHAT_INTERACTION => '#00CDCD'               
    }
  end
  
end
