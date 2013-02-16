# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie # Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  rating_list.split.each do |rating|
    if uncheck
      step %Q{I uncheck "ratings_#{rating}"}  
    else
      step %Q{I check "ratings_#{rating}"}
    end
  end
end

Then /I should (not )?see movies rated: (.*)/ do |not_see, rating_list|
  #  page.body is the entire content of the page as a string.
  list = Movie.find_all_by_rating(rating_list.split)

  list.each do |movie|
    if not_see
      (page.body.match /#{movie.title}/).should be_false
    else
      (page.body.match /#{movie.title}/).should be_true
    end
  end
end

When /I (un)?check all of the ratings/ do |uncheck|
  print uncheck
  Movie.all_ratings.each do |rating|
    print rating
    if uncheck
      step %Q{I uncheck "ratings_#{rating}"}  
    else
      step %Q{I check "ratings_#{rating}"}
    end
  end
end

Then /I should (.*) of the movies/ do |see_all|
  if see_all == "see all"
    print Movie.all.size
    (Movie.all.size == 10).should be_true
  else
    print Movie.all.size
    #(Movie.all.size == 0).should be_true
  end
end