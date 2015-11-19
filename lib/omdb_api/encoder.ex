defmodule OMDBApi.Encoder do
  def encode(title, :search) do
    "?s=#{URI.encode_www_form(title)}"
  end
  def encode(title, year, :search) do
    "?s=#{URI.encode_www_form(title)}&y=#{year}"
  end

  def encode(title, year, :movie_info) do
    "?t=#{URI.encode_www_form(title)}&y=#{year}&plot=short"
  end
end
