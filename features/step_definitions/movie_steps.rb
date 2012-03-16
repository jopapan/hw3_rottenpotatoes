# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
#  p movie["title"]
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie["title"], :release_date => movie["release_date"], :rating => movie["rating"])
  end
#  assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  reg = Regexp.new(".*#{e1}.*#{e2}.*", Regexp::MULTILINE)
    if page.body.respond_to? :should
       page.body.should =~ reg
    else
       assert_match(reg, page.body, "lalala")
    end

#  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
#  assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
#  puts page.body
step %Q(I am on the RottenPotatoes home page)
  ratings = rating_list.split(/,\s?/)
  ratings.each do |rating|
#p "ratings_#{rating}"
      if uncheck
         step %Q(I uncheck "ratings_#{rating}")
      else
         step %Q(I check "ratings_#{rating}")
      end
      step %Q(I press "ratings_submit")
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /I should (not )?see the following movies: (.*)/ do |notsee, movie_list|
  movies = movie_list.split(/,\s?/)
  vis = notsee ? 'not ' : ''
    movies.each do |movie|
        step %Q(I should #{vis}see "#{movie}")
    end
end

Then /I should see (\d+) movies/ do |num|
     rows = page.all('#movies tbody tr').size.to_s
     puts rows
     if rows.respond_to? :should
       rows.should == num
     else
       assert_equal rows,num
     end
end

Then /I should see no movies/ do
     step %Q(I should see 0 movies)
end

Then /I should see all of the movies/ do
    count = Movie.all.length
    step %Q(I should see #{count} movies)
end
