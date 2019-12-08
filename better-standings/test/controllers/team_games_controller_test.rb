require 'test_helper'

class TeamGamesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get team_games_show_url
    assert_response :success
  end

end
