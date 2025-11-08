class Cliente < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :emprestimos, dependent: :destroy

  before_validation :normalize_telefone

  validates :nome, presence: true, length: { maximum: 150 }
  validates :telefone,
            presence: true,
            format: { with: /\A\+?\d{10,15}\z/, message: "deve conter entre 10 e 15 dígitos" }
  validates :endereco, presence: true, length: { maximum: 255 }
  validates :data_nascimento, presence: true
  validate :data_nascimento_no_passado

  private

  def normalize_telefone
    self.telefone = telefone.to_s.gsub(/\D/, "")
  end

  def data_nascimento_no_passado
    return if data_nascimento.blank?

    if data_nascimento > Date.current
      errors.add(:data_nascimento, "não pode estar no futuro")
    end
  end
end
