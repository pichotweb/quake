require "test_helper"

class KillTest < ActiveSupport::TestCase
  
  test "should allow register a kill without killer" do
    world_kill = Kill.new({
      victim: players(:one),
      game: games(:one)
    })

    assert world_kill.save, world_kill.errors.full_messages.to_sentence
  end

end
