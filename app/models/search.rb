class Search < ApplicationRecord

  belongs_to :session
  
  def self.get_most_frequent_searches
    frequent_searches = []
    Search.all(:select => "query, count(query) as query_count", :group => "query", :order => "query_count DESC", :limit => 7).each do |row|
      frequent_searches << row[:query]
    end
      frequent_searches
  end

end
