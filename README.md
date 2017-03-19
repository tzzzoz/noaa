# Weather

[NOAA](https://www.ncdc.noaa.gov/cdo-web/webservices/v2#gettingStarted)(National Oceanic and Atmospheric Administration) supplys a full of web services to allow users to fetch weather measurements. This mini project is an exercise in the chapter 13 of the book [« Programming Elixir 1.3 »](https://pragprog.com/book/elixir13/programming-elixir-1-3). This helps me to get familiar with Elixir programming and organization of an Elixir project. It implemented only three important APIs of NOAA: `datasets`, `locations`, `data`. If you are interested, you can extend it through the implementation of other APIs.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `weather` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:weather, "~> 0.1.0"}]
    end
    ```

  2. Ensure `weather` is started before your application:

    ```elixir
    def application do
      [applications: [:weather]]
    end
    ```

