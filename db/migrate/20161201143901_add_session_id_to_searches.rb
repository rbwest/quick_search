class AddSessionIdToSearches < ActiveRecord::Migration[5.0]
  def change
    add_reference :searches, :session, foreign_key: true, type: :uuid
  end
end
