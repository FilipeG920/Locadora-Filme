require "test_helper"

class CopiaFilmesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @copia_filme = copia_filmes(:one)
  end

  test "should get index" do
    get copia_filmes_url
    assert_response :success
  end

  test "should get new" do
    get new_copia_filme_url
    assert_response :success
  end

  test "should create copia_filme" do
    assert_difference("CopiaFilme.count") do
      post copia_filmes_url, params: { copia_filme: { filme_id: @copia_filme.filme_id, status: @copia_filme.status, tipo_midia: @copia_filme.tipo_midia } }
    end

    assert_redirected_to copia_filme_url(CopiaFilme.last)
  end

  test "should show copia_filme" do
    get copia_filme_url(@copia_filme)
    assert_response :success
  end

  test "should get edit" do
    get edit_copia_filme_url(@copia_filme)
    assert_response :success
  end

  test "should update copia_filme" do
    patch copia_filme_url(@copia_filme), params: { copia_filme: { filme_id: @copia_filme.filme_id, status: @copia_filme.status, tipo_midia: @copia_filme.tipo_midia } }
    assert_redirected_to copia_filme_url(@copia_filme)
  end

  test "should destroy copia_filme" do
    assert_difference("CopiaFilme.count", -1) do
      delete copia_filme_url(@copia_filme)
    end

    assert_redirected_to copia_filmes_url
  end
end
