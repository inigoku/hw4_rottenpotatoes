require 'spec_helper'

describe MoviesController do
  describe 'movie lifecycle' do
    it 'should call the model method that creates a movie' do
      fake_movie = mock('movie')
      fake_movie.stub(:title).and_return('Star Wars')
      Movie.should_receive(:create!).and_return(fake_movie)
      get :create 
    end
    it 'should call the model method that destroys a movie' do
      fake_movie = mock('movie')
      fake_movie.stub(:title).and_return('Star Wars')
      Movie.stub(:find).with("1").and_return(fake_movie)
      fake_movie.should_receive(:destroy)
      get :destroy , {:id => 1}
    end
  end
  describe 'finding movies with same director' do
    describe 'checking happy path' do
      before :each do
        @fake_results = [mock('movie1'), mock('movie2')]
        Movie.create!(:title => 'My Good Movie', :director => 'Chiquito')
      end
      it 'should call the model method that performs the similar movies search' do
        Movie.should_receive(:find_similar).with("1").
          and_return(@fake_results)   
        get :similar, {:id => 1}
      end
      describe 'after valid search' do
        before :each do
          Movie.stub(:find_similar).and_return(@fake_results)
          get :similar, {:id => 1}
        end
        it 'should select the Similar template for rendering' do    
          response.should render_template('similar')
        end
        it 'should make the similar movies search results available to that template' do
          assigns(:movies).should == @fake_results
        end
      end
    end
    describe 'checking sad path' do
      it 'should redirect to index page if no director' do
        Movie.create!(:title => 'My Bad Movie', :director => '')
        get :similar, {:id => 1}
        response.should redirect_to movies_path
      end
    end
  end
end