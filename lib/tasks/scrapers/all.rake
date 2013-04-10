namespace :db do
  namespace :scrape do
    desc 'Scrape all'
    task all: ['db:scrape:ifc', 'db:scrape:angelika', 'db:scrape:village_east']
  end
end
