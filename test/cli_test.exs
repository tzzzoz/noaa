defmodule CLITest do
  use ExUnit.Case
  doctest Weather

  import Weather.CLI, only: [ parse_args: 1]

  describe "parsing for :help option" do
    test ":help returned by parsing with -h and --help option" do
      assert parse_args(["-h", "anything"]) == :help
      assert parse_args(["--help", "anything"]) == :help
    end
  end

  describe "parsing for :datasets command" do
    test "command and default value returned if only command given" do
      assert parse_args(["datasets"]) == {:datasets, %{count: 10}}
    end

    test "command and given value returned if command and params given" do
      assert parse_args(["datasets", "--count", 5]) == {:datasets, %{count: 5}}
    end
  end

  describe "parsing for :locations command" do
    test "command and default value returned if only cmmand given" do
      assert parse_args(["locations"]) == {:locations, %{count: 10}}
    end
    
    test "command and given value returned if command and params given" do
      assert parse_args(["locations", "--count", 5]) == {:locations, %{count: 5}}
    end
  end

  describe "parsing for :data command" do
    test "command and given params returned if command and params given" do
      assert parse_args([
                          "data", 
                          "--datasetId", "A", 
                          "--locationId", "B", 
                          "--from", "2017-03-12", 
                          "--to", "2017-03-15"
                        ]) == {:data, %{datasetId: "A", locationId: "B", from: "2017-03-12", to: "2017-03-15"}}
    end

    test ":help returned if no params given" do
      assert parse_args(["data"]) == :help
    end
  end
end
