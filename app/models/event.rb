class Event < ApplicationRecord
  belongs_to :session

  before_create do
    self.created_at_string = DateTime.now.strftime("%Y-%m-%d")
  end

end
