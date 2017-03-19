defmodule Weather.CLI do
  @moduledoc """
  Handle the command line parsing and dispatch
  to the various functions that end up generating
  a table of weather data for the corresponding command given
  """
  import Weather.Webservice, only: [datasets_url: 1, locations_url: 1, data_url: 1]
  import Weather.TableFormatter, only: [print_table_for_columns: 2]
  @switchs [ 
    help:       :boolean,
    count:      :integer,
    datasetId:  :string,
    locationId: :string,
    from:       :string,
    to:         :string
  ]
  @commands ["datasets", "locations", "data"]
  @default_count 10
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switchs: @switchs, aliases: [h: :help])
    case parse do
      {[help: true], _, _}
        -> :help
      {[count: count], ["datasets"], _}
        -> {:datasets, %{count: count}}
      {[], ["datasets"], _}
        -> {:datasets, %{count: @default_count}}
      {[count: count], ["locations"], _}
        -> {:locations, %{count: count}}
      {[], ["locations"], _}
        -> {:locations, %{count: @default_count}}
      {params, ["data"], _}
        -> parse_remains(params)
      _ -> :help
    end
  end

  def parse_remains([datasetId: datasetid, locationId: locationid, from: from, to: to]) do
    {:data, %{datasetId: datasetid, locationId: locationid, from: from, to: to}}
  end

  def parse_remains([]) do
    :help
  end

  def process(:help) do
  end

  def process(params) do
    params
    |> build_url
    |> Weather.Webservice.fetch
    |> decode_response
    |> get_data
    |> print
  end

  def build_url({:datasets, %{count: count}}), do: datasets_url(count)

  def build_url({:locations, %{count: count}}), do: locations_url(count)

  def build_url({:data, params}), do: data_url(params)

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from NOAA: #{message}"
    System.halt(2)
  end

  def get_data(%{"results" => rows}), do: rows

  def print(rows=[head | _]) do
    headers = Map.keys(head)
    print_table_for_columns(rows, headers)
  end
end
