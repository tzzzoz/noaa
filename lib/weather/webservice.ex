defmodule Weather.Webservice do
  @token Application.get_env(:weather, :ncdc_token)
  @base_url Application.get_env(:weather, :base_url)

  def datasets_url(count) do
    @base_url <> "datasets?limit=#{count}"
  end

  def locations_url(count) do
    @base_url <> "locations?limit=#{count}"
  end

  def data_url(params = %{}) do
    query =  Enum.reduce(params, "", fn({k, v}, acc)-> acc <> v end)
    @base_url <> query
  end

  def fetch(url) do
    headers = [token: @token]
    url
    |> HTTPoison.get(headers)
    |> handle_response
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({_, %{status_code: status, body: body}}) do
    {:error, Poison.Parser.parse!(body)}
  end

  def handle_response({_error_code, %HTTPoison.Error{id: nil, reason: reason}}) do
    {:error, [{"message", reason}]}
  end
end
