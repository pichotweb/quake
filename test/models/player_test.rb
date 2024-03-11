require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    @game = games(:one)
  end
  

  test "shoul update player's kill score" do
    player = players :one

    player.update_kill_score

    assert_equal 3, player.score, "Score was not updated!"
  end

  test 'should return team_label' do
    blue_team_player = players :one
    red_team_player = players :two

    assert_equal 'Blue', blue_team_player.team_label
    assert_equal 'Red', red_team_player.team_label
  end

  test "should find a player in memory by session id" do

    non_persisted_game = Game.new
    non_persisted_game.players.build({
      name: 'Dark kamus',
      session_id: 1
    })

    assert_equal 'Dark kamus', Player::find_in_memory(non_persisted_game, 1).name, "Didn't find player by session id"
  end

  test 'should update player data in memory' do
    non_persisted_game = Game.new
    player = non_persisted_game.players.build({
      name: 'Dark kamus',
      session_id: 1
    })
    
    Player.upsert_in_memory(non_persisted_game, {name: 'Edited', session_id: 1})

    assert_equal 1, non_persisted_game.players.length, "Duplicated an existing player"
    assert_equal 'Edited', player.name, "Fail to update player's name"
  end

end

