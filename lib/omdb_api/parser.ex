defmodule OMDBApi.Parser do
  def parse(response, :search) do
    case response do
      [{:Error, "Movie not found!"}, {:Response, "False"}] ->
        {:not_found, "Movie not found"}
      _ ->
        response[:Search] |> List.first
    end
  end

  def parse(data, :normalize) do
    case data do
      {:not_found, _} ->
        %{:error => "Movie not found, please refine search result."}
      %{"Title" => title, "Year" => year} ->
        {:ok, title, year}
    end
  end

  def parse(response, :movie_info) do
    %{
      :title => response[:Title],
      :year => response[:Year],
      :poster => response[:Poster],
      :imdbid => response[:imdbID],
      :director => response[:Director],
      :actors => response[:Actors],
      :plot => response[:Plot],
      :rating => response[:imdbRating],
      :runtime => response[:Runtime]
    }
  end
end
