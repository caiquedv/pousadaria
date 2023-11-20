class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  
  has_one :guesthouse, dependent: :destroy
  has_many :rooms, through: :guesthouse

  has_many :reservations

  validates :name, :role, presence: true
  validates :social_security_number, presence: true, if: :guest?

  after_initialize :set_default_role, if: :new_record?

  enum role: { guest: 4, host: 8 }

  def description
    "#{name} - #{email} - #{I18n.t(role)}"
  end    

  private

  def set_default_role
    self.role ||= :guest
  end
end
