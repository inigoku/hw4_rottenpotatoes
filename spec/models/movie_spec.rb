require 'spec_helper'

describe Movie do
  describe 'searching movies with same director' do
    it 'should find movies searching by ' do
      fake_movie = mock('movie')
      fake_movie.should_receive(:director).and_return('George Lucas')
      Movie.should_receive(:find).with(1).and_return(fake_movie)
      Movie.should_receive(:find_all_by_director).with('George Lucas')
      Movie.find_similar(1)
    end
    it 'should raise an error if no director for that movie' do
      fake_movie = mock('movie')
      fake_movie.should_receive(:director).and_return('')
      Movie.should_receive(:find).with(1).and_return(fake_movie)
      Movie.should_not_receive(:find_all_by_director)
      lambda { Movie.find_similar(1) }.
        should raise_error(Movie::NoDirectorError)     
    end
  end
end