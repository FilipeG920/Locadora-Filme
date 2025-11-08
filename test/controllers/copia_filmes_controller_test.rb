require "test_helper"

class CopiaFilmesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @copia_filme = copia_filmes(:one)
  end

  test "should get index" do
    get copia_filmes_url
    assert_response :success
  end

  test "should show copia_filme" do
    get copia_filme_url(@copia_filme)
    assert_response :success
  end
end
