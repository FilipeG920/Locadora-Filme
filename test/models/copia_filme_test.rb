require "test_helper"

class CopiaFilmeTest < ActiveSupport::TestCase
  test "disponiveis scope returns only copies marked as available" do
    disponivel = copia_filmes(:available)
    alugado = copia_filmes(:rented)

    resultado = CopiaFilme.disponiveis

    assert_includes resultado, disponivel
    refute_includes resultado, alugado
  end

  test "disponivel? returns true only when status is disponivel" do
    assert_predicate copia_filmes(:available), :disponivel?
    refute_predicate copia_filmes(:rented), :disponivel?
  end
end
