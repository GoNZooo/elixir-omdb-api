defmodule OMDBApi do
  use HTTPoison.Base

  def process_url(url) do
    "http://omdbapi.com/" <> url
  end

  def process_response_body(body) do
    body
     |> Poison.decode!
     |> Enum.map( fn({k,v}) -> {String.to_atom(k), v} end)
  end

  def search(title) do
    url = "?s=#{URI.encode_www_form(title)}"
    response = get!(url).body
    case response do
      [{:Error, "Movie not found!"}, {:Response, "False"}] ->
        {:not_found, "Movie not found"}
      _ ->
        response[:Search] |> List.first
    end
  end
  def search(title, year) do
    url = "?s=#{URI.encode_www_form(title)}&y=#{year}"
    response = get!(url).body
    case response do
      [{:Error, "Movie not found!"}, {:Response, "False"}] ->
        {:not_found, "Movie not found"}
      _ ->
        response[:Search] |> List.first
    end
  end

  def movie_info(title) do
    case search(title) do
      %{"Title" => normalized_title, "Year" => year,
        "Poster" => poster, "imdbID" => imdb_id} -> 
        url = "?t=#{URI.encode_www_form(normalized_title)}&y=#{year}&plot=short"
        data = get!(url).body
        director = data[:Director]
        actors = data[:Actors]
        plot = data[:Plot]
        rating = data[:imdbRating]
        runtime = data[:Runtime]
        %{:title => normalized_title, :year => year, :poster => poster,
          :imdbid => imdb_id, :director => director, :actors => actors,
          :plot => plot, :rating => rating, :runtime => runtime}
      {:not_found, _} ->
        %{:error => "Movie not found, please refine search result."}
    end
  end
end
