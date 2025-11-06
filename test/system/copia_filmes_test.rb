require "application_system_test_case"

class CopiaFilmesTest < ApplicationSystemTestCase
  setup do
    @copia_filme = copia_filmes(:one)
  end

  test "visiting the index" do
    visit copia_filmes_url
    assert_selector "h1", text: "Copia filmes"
  end

  test "should create copia filme" do
    visit copia_filmes_url
    click_on "New copia filme"

    fill_in "Filme", with: @copia_filme.filme_id
    fill_in "Status", with: @copia_filme.status
    fill_in "Tipo midia", with: @copia_filme.tipo_midia
    click_on "Create Copia filme"

    assert_text "Copia filme was successfully created"
    click_on "Back"
  end

  test "should update Copia filme" do
    visit copia_filme_url(@copia_filme)
    click_on "Edit this copia filme", match: :first

    fill_in "Filme", with: @copia_filme.filme_id
    fill_in "Status", with: @copia_filme.status
    fill_in "Tipo midia", with: @copia_filme.tipo_midia
    click_on "Update Copia filme"

    assert_text "Copia filme was successfully updated"
    click_on "Back"
  end

  test "should destroy Copia filme" do
    visit copia_filme_url(@copia_filme)
    click_on "Destroy this copia filme", match: :first

    assert_text "Copia filme was successfully destroyed"
  end
end
