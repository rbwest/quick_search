class Session < ApplicationRecord
  has_many :searches
  has_many :events

  before_create do
    self.created_at_string = DateTime.now.strftime("%Y-%m-%d")
  end

end
