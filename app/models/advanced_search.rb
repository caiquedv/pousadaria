class AdvancedSearch
  include ActiveModel::Model

  attr_accessor :city, :district, :capacity, :accepts_pets, :bathroom, :balcony,
                :air_conditioning, :television, :closet, :safe, :accessibility

  def search_guesthouses
    guesthouses = Guesthouse.where(active: true)
    guesthouses = guesthouses.where('lower(city) LIKE ?', "%#{city.downcase}%") if city.present?
    guesthouses = guesthouses.where('lower(district) LIKE ?', "%#{district.downcase}%") if district.present?

    guesthouses = guesthouses.left_joins(:rooms).distinct
    guesthouses = guesthouses.where('rooms.capacity >= ?', capacity.to_i) if capacity.present?

    guesthouses = apply_boolean_filters(guesthouses)

    guesthouses
  end

  private

  def apply_boolean_filters(guesthouses)
    if accepts_pets == '1'
      guesthouses = guesthouses.where(accepts_pets: true)
    end

    room_filters = {}
    room_filters['rooms.bathroom'] = true if bathroom == '1'
    room_filters['rooms.balcony'] = true if balcony == '1'
    room_filters['rooms.air_conditioning'] = true if air_conditioning == '1'
    room_filters['rooms.television'] = true if television == '1'
    room_filters['rooms.closet'] = true if closet == '1'
    room_filters['rooms.safe'] = true if safe == '1'
    room_filters['rooms.accessibility'] = true if accessibility == '1'

    guesthouses = guesthouses.where(room_filters) if room_filters.any?

    guesthouses
  end
end
