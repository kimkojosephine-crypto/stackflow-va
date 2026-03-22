class VaProfile < ApplicationRecord
  VALID_NICHES = [
    "General VA",
    "Travel & Itinerary VA",
    "Creative VA",
    "Social Media VA",
    "Lead Gen VA",
    "Real Estate VA",
    "Tech VA"
  ].freeze

  validates :niche, inclusion: {
    in: VALID_NICHES,
    message: "Please select a valid VA niche from the list"
  }

  validates :budget, numericality: {
    greater_than_or_equal_to: 0,
    message: "Please enter a budget of 0 or more"
  }, allow_blank: false
end
