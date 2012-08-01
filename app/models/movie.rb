class Movie < ActiveRecord::Base

  class Movie::NoDirectorError < StandardError ; end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_similar(id)
    director = Movie.find(id).director
    if director == '' 
      raise Movie::NoDirectorError
    end
    Movie.find_all_by_director(director)
  end
end
