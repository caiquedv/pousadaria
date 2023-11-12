class HomeController < ApplicationController
  
  def index
    @recent_guesthouses = Guesthouse.all_active.order(created_at: :desc).limit(3)
    @other_guesthouses = Guesthouse.all_active.where.not(id: @recent_guesthouses.pluck(:id))
    @guesthouses = Guesthouse.all_active
  end
end