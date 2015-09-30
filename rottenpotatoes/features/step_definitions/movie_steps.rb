# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    @movie = Movie.new(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
    @movie.save()

  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.assert_text /#{e1}(.*)#{e2}/m
  # if page.body =~ /#{e1}(.*)#{e2}/m
  # else
   #  raise "Movie #{e1} should be before #{e2}"
  # end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list = rating_list.split(', ')
  if uncheck
      rating_list.each do |rating|
        actualVal = "ratings_" + rating
        uncheck(actualVal)
      end
  else
      rating_list.each do |rating|
      actualVal = "ratings_" + rating
      check(actualVal)  
    end
  end  
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  @movies = Movie.all
  @movies.each do |movie|
    page.should have_content(movie.title)
  end 
end
