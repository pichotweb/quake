require "test_helper"

class GameTest < ActiveSupport::TestCase
  

  def setup
    @game = games :one
  end

  test "should set game statistics before save" do 
    new_game = Game.new

    2.times do |i|
      new_game.players.build({
        session_id: i,
        team: 'g_blueteam'
      })
    end

    killer = new_game.players.first
    victim = new_game.players.last
    
    3.times { new_game.kills.build(killer: new_game.players[0], victim: new_game.players[1]) }
    1.times { new_game.kills.build(victim: new_game.players[0]) }

    assert new_game.save, new_game.errors.full_messages.to_sentence

    assert_equal 2, new_game.players_count, "Player count didn't match"
    assert_equal 4, new_game.kills_count, "Kills count didn't match"
  end

  test "should calculate players score after a game shutdown" do
    @game.is_shuting_down = true
    assert @game.save, @game.errors.full_messages.to_sentence

    @game.players.each do |player|
      assert_not_equal 0, player.score, "The player #{player.id} score was zero"
    end
  end

  test "should return server params as JSON" do
    assert_instance_of Hash, @game.server_params
    assert_includes @game.server_params, 'g_maxGameClients'
  end

end
