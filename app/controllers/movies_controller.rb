class MoviesController < ApplicationController
  before_action :check_for_login

  def index
    @movies = @current_user.movies
    @movies = @movies.sort_by { |movie| movie[:title]}
  end

  def show
    @movie = Movie.find params[:id]
    @libraries = @current_user.libraries
  end

  def edit
    @movie = Movie.find params[:id]
    @libraries = @current_user.libraries
  end

  def update
    movie = Movie.find params[:id]
    movie.update movie_params
    redirect_to movie
  end

  def new
    @movie = Movie.new
    @libraries = @current_user.libraries
  end

  def create
    @movie = Movie.new movie_params
    @current_user.movies << @movie
    @movie.save
    redirect_to @movie
  end

  def add_movie
    imdbID = params[:id]

    if (Movie.all.find_by :imdbID => imdbID)
      @movie = Movie.find_by :imdbID => imdbID

    else
      @movie = Movie.create_movie_from_imdb imdbID
      @current_user.movies << @movie
    end
    redirect_to movie_path(@movie.id)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    redirect_to movies_path
  end

  private
  def movie_params
    params.require(:movie).permit(:title, :cover, :year, :duration, :synopsis, :genre_ids, :actor_ids, :director_id, :library_ids, :user_id, :imdbID)
    # add => [] for many to many associations
  end
end
