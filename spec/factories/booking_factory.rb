FactoryBot.define do
  factory :booking do
    start { 1.day.from_now }
    add_attribute(:end) { 2.days.from_now }
    room
  end
end