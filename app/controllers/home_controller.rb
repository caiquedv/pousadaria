class HomeController < ApplicationController
  

  def index
    @guesthouses = Guesthouse.all_active
  end
end