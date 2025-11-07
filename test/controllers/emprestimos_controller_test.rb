require "test_helper"

class EmprestimosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cliente = clientes(:one)
    sign_in @cliente
    @emprestimo = emprestimos(:one)
    @available_copy = copia_filmes(:available)
  end

  test "should get index" do
    get emprestimos_url
    assert_response :success
  end

  test "should get new" do
    get new_emprestimo_url
    assert_response :success
  end


  # emprestimo: { cliente_id: @emprestimo.cliente_id, copia_filme_id: @emprestimo.copia_filme_id, data_devolucao_efetiva: @emprestimo.data_devolucao_efetiva, data_emprestimo: @emprestimo.data_emprestimo, data_prevista_devolucao: @emprestimo.data_prevista_devolucao, valor_locacao: @emprestimo.valor_locacao, valor_multa: @emprestimo.valor_multa }

  test "should create emprestimo" do
    assert_difference("Emprestimo.count") do
      post emprestimos_url, params: { copia_filme_id: @available_copy.id }
    end

    assert_redirected_to emprestimo_url
  end

  test "should show emprestimo" do
    get emprestimo_url(@emprestimo)
    assert_response :success
  end

  test "should get edit" do
    get edit_emprestimo_url(@emprestimo)
    assert_response :success
  end

  # emprestimo: { cliente_id: @emprestimo.cliente_id, copia_filme_id: @emprestimo.copia_filme_id, data_devolucao_efetiva: @emprestimo.data_devolucao_efetiva, data_emprestimo: @emprestimo.data_emprestimo, data_prevista_devolucao: @emprestimo.data_prevista_devolucao, valor_locacao: @emprestimo.valor_locacao, valor_multa: @emprestimo.valor_multa }

  test "should update emprestimo" do
    patch emprestimo_url(@emprestimo), params: { emprestimo: { valor_locacao: 25.0 } }
    assert_redirected_to emprestimo_url(@emprestimo)
    @emprestimo.reload
    assert_in_delta 25.0, @emprestimo.valor_locacao.to_f, 0.01
  end

  test "should destroy emprestimo" do
    assert_difference("Emprestimo.count", -1) do
      delete emprestimo_url(@emprestimo)
    end

    assert_redirected_to emprestimos_url
  end
end
