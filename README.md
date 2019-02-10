# Mostrous controller action refactor

### Your task is simple.

Refactor the monstrous action in BookingsController and write specs for it.

You can use any pattern you want (Queries, ServiceObjects, UseCases, etc.), but please don't use any external tools for checking for colliding booking dates (gems, APIs, etc.).

Any other gem/library that does not solve the task for you is fine with us. :)

Good luck!


### Solution

- Installed RSpec as the testing framework.
- Installed FactoryBot to use factories instead of fixtures.
- Installed shoulda_matchers for helpful RSpec matchers. e.g `should validate_presence_of`
- The solution is also available in a (GitHub Repo)[https://github.com/shangardezi/calendar-bookings] (it's private repo so access needs to be granted).

Design choices:
- Validations were moved to the Booking model. Currently, as the model is simple and small this is sufficient. However, if more validations were to bloat the model, we could extract these into a seperate validator object.
- Checking for collisions is done in one query, which checks for any bookings which start before the new booking end date and end after the new booking start date. Computationally, this is much more efficient than looping over each booking.

