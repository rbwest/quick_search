class Session < ApplicationRecord
  has_many :searches
  has_many :events
end
