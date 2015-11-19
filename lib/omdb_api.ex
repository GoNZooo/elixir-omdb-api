defmodule OMDBApi do
  alias OMDBApi.Encoder
  alias OMDBApi.Parser
  alias OMDBApi.Fetcher

  def search(title) do
    title
    |> Encoder.encode(:search)
    |> Fetcher.fetch
    |> Parser.parse :search
  end
  def search(title, year) do
    Encoder.encode(title, year, :search)
    |> Fetcher.fetch
    |> Parser.parse :search
  end
  
  defp normalize(title) do
    Parser.parse search(title), :normalize
  end
  defp normalize(title, year) do
    Parser.parse search(title, year), :normalize
  end

  defp get_normalized(title, year) do
    Encoder.encode(title, year, :movie_info)
    |> Fetcher.fetch
    |> Parser.parse :movie_info
  end

  def movie_info(title) do
    normalized_result = normalize title 
    case normalized_result do
      {:ok, normalized_title, year} ->
        get_normalized normalized_title, year
      _ ->
        normalized_result
    end
  end
  def movie_info(title, year) do
    normalized_result = normalize title, year 
    case normalized_result do
      {:ok, normalized_title, year} ->
        get_normalized normalized_title, year
      _ ->
        normalized_result
    end
  end
end
