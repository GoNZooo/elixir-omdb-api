defmodule OMDBApi.Fetcher do
  use HTTPoison.Base

  def process_url(url) do
    "http://omdbapi.com/" <> url
  end

  def process_response_body(body) do
    body
     |> Poison.decode!
     |> Enum.map( fn({k,v}) -> {String.to_atom(k), v} end)
  end

  def fetch(url) do
    get!(url).body
  end
end
