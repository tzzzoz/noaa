defmodule Weather.CLI do
  @moduledoc """
  Handle the command line parsing and dispatch
  to the various functions that end up generating
  a table of weather data for the corresponding command given
  """
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
end
