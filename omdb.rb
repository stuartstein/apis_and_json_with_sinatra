require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

def imdb_pull(search_key, search_val)

  result = Typhoeus.get("http://www.omdbapi.com/", :params => {search_key => search_val})
  result = JSON.parse(result.body)
  result

end


get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]
  
  # Make a request to the omdb api here!
  result = imdb_pull(:s, search_str)
  
  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"

  result["Search"].each do |movie|
    html_str += "<li><a href = \"../poster/#{movie["imdbID"]}\">#{movie["Title"]} - #{movie["Year"]}</a></li>"
  end
    html_str += "</ul></body></html>"
end

get '/poster/:imdb' do |imdb_id|
  
  result = imdb_pull(:i, imdb_id)
  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str += "<h3>#{result["Title"]}</h3>"
  html_str += "<img src=\" #{result["Poster"]} \"><br />"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end

