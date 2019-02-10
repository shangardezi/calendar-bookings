class Booking < ActiveRecord::Base
  validate :start_date_is_before_end_date, :availability

  validates_presence_of :start, :end, :room

  belongs_to :room

  private

  def start_date_is_before_end_date
    return unless start || self.end

    if start > self.end
      errors.add(:start, 'cannot be after the end date')
      errors.add(:end, 'cannot be before the start date')
    end
  end

  def availability
    return unless room

    bookings = Booking.where('start <= ? AND end >= ?', self.end, start)
    unless bookings.empty?
      errors.add(:base, 'an existing booking is taking place during this time')
    end
  end
end
