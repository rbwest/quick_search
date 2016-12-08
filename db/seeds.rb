##
# Generates a random query

def random_query
  # Use a fake query
  # TODO: better random queries
  'query ' + (rand*5000).to_i.to_s
end

##
# Generates a random (category, action) pair for an event

def random_category_action
  category = (QuickSearch::Engine::APP_CONFIG['searchers'] + ['spelling-suggestion', 'result-types', 'doi-trap', 'more-options']).sample.dasherize
  # Default action is a click
  action = 'click'

  # Typically, serves only happen for these categories
  if category == 'best-bets' || category == 'spelling-suggestion'
    action = ['click', 'serve'].sample
  end

  return category, action
end

##
# Generates a random item for an event, based on the category

def random_item(category)
  if category == 'best-bets'
    # Sample a random Best Bet type from a static list
    ['webofscience', 'googlescholar', 'ieee', 'pubmed', 'morningstar', 'wgsn', 'standards', 'dissertation', 'refworks', 'ibis', 'proquest',
     'psychinfo', 'sciencemagazine', 'sciencedirect', 'petition', 'compendex', 'jstor', 'software', 'naturejournal'].sample
  elsif category == 'doi-trap'
    # Sample a random DOI from a static list
    ['10.1080/10510974.2013.797483', '10.1111/j.1468-2958.1996.tb00379.x', 'http://dx.doi.org/10.1063/1.2741534', 'DOI: 10.1007/BF02887151',
     '10.1039/C4RA16247A', '10.1002/sce.3730670213', 'DOI: 10.1007/s40596-014-0241-5', '10.1080/15348423.2012.697437',
     'http://dx.doi.org/10.3168/jds.S0022-0302(86)80552-5', 'DOI: 10.1023/A:1005204727421', '10.1039/C3TA00019B', 'doi:10.1038/leu.2016.163',
     'DOI: 10.1007/s10853-013-7374-x', 'doi: 10.1016/0167-2738(91)90233-2', 'doi: 10.1179/000705992798268927', '10.1038/nphys3794',
     'doi: 10.1149/1.1393288', '10.1080/1554480X.2014.926052', '10.1002/adma.201506234', '10.1080/00958972.2016.1176158'].sample
  elsif category == 'result-types'
    # Use a defined searcher for found types
    (QuickSearch::Engine::APP_CONFIG['searchers']).sample.dasherize
  elsif category == 'more-options'
    # Use a result number for more-options
    ['result-1', 'result-2', 'result-3', 'result-4'].sample
  elsif category == 'spelling-suggestion'
    # Use a fake string
    'spelling suggestion ' + (rand*200).to_i.to_s
  else
    # Use one of the typical options for a searcher click (or anything else we haven't handled above)
    ['heading', 'result-1', 'result-2', 'result-3', 'see-all-results', 'no-results', 'error'].sample
  end 
end



##
# Creates 15,000 random sessions to seed the QS stats database. Each session will have between 0-8 random queries and
# 0-15 random events. Measures are taken to make random data somewhat realistic. Session occur at random times over the
# past 2 years

15000.times do |i|
  # Create session with random parameters. Simulate 2 years worth of data
  session = Session.create(id: SecureRandom.uuid, expiry: rand(2.years).seconds.ago, on_campus: [true, false].sample, is_mobile: [true, false].sample)
  # Update created_at (since we use this as session start time) to be within 10 minutes of the expiry of the session
  session.created_at = session.expiry - (rand*10).minutes
  session.save

  # Generate 0-8 random searches, occuring at random times during the current session
  (rand*8).to_i.times do |j|
    session.searches.create(query: random_query, page: '/', created_at: Time.at((session.expiry.to_f - session.created_at.to_f)*rand + session.created_at.to_f))
  end

  # Generate 0-15 random events, occuring at random times during the current session
  (rand*15).to_i.times do |k|
    category, action = random_category_action
    item = random_item(category)
    session.events.create(category: category, item: item, query: random_query, action: action, created_at: Time.at((session.expiry.to_f - session.created_at.to_f)*rand + session.created_at.to_f))
  end
end


