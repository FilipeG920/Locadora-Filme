require "test_helper"

class Admin::CopiaFilmesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
    @filme = filmes(:one)
    @copia_filme = copia_filmes(:one)
  end

  test "should require authentication" do
    get new_admin_filme_copia_filme_url(@filme)
    assert_redirected_to new_admin_session_url
  end

  test "should get new" do
    sign_in @admin

    get new_admin_filme_copia_filme_url(@filme)
    assert_response :success
  end

  test "should create copia_filme" do
    sign_in @admin

    assert_difference("CopiaFilme.where(filme: @filme).count", 1) do
      post admin_filme_copia_filmes_url(@filme), params: { copia_filme: { status: "Disponível", tipo_midia: "4K" } }
    end

    assert_redirected_to admin_filme_url(@filme)
    assert_equal "Cópia cadastrada com sucesso!", flash[:notice]
  end

  test "should update copia_filme" do
    sign_in @admin

    patch admin_filme_copia_filme_url(@filme, @copia_filme), params: { copia_filme: { status: "Alugado", tipo_midia: @copia_filme.tipo_midia } }
    assert_redirected_to admin_filme_url(@filme)
    assert_equal "Alugado", @copia_filme.reload.status
  end

  test "should destroy copia_filme" do
    sign_in @admin

    assert_difference("CopiaFilme.where(filme: @filme).count", -1) do
      delete admin_filme_copia_filme_url(@filme, @copia_filme)
    end

    assert_redirected_to admin_filme_url(@filme)
  end
end
