# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)   
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  result = page.body.index(e1) - page.body.index(e2)
  expect(result).to be < 0
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratingsList = rating_list.delete(" ").split(",") #remove white space first
  ratingsList.each do |rating|
    if uncheck
        steps "When I uncheck #{rating}"  
    else
        steps "When I check #{rating}" 
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  rows = page.all(:css, 'table tr').size
  movies = Movie.all
  expect(rows).to eq movies.length + 1
    
end

Then /I should see sort movies alphabetically/ do
    movies = Movie.all.order("title")
    (movies.length - 2).times do |i|
       steps 'Then I should see "' + movies[i].title + '" before "' + movies[i + 1].title + '"'
    end
end

Then /I should see sort movies in increasing order of release date/ do
    movies = Movie.all.order("release_date")
    (movies.length - 2).times do |i|
       steps 'Then I should see "' + movies[i].release_date.to_s + '" before "' + movies[i + 1].release_date.to_s + '"'
    end
end    
