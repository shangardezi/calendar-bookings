class Booking < ActiveRecord::Base
  validate :start_date_is_before_end_date
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
end
