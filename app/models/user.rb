class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  
  validates :name, :role, presence: true

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
