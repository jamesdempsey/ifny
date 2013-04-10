namespace :db do
  namespace :scrape do
    desc 'Scrape all'
    task all: %w(db:scrape:ifc db:scrape:angelika db:scrape:village_east
                 db:scrape:nitehawk)
  end
end
