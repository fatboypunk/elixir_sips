defmodule Mix.Tasks.And do
  @moduledoc """
  Mix task to run the neural network for and.
  """

  use Mix.Task

  alias NeuralNetwork.{Network, Trainer, Layer, Neuron}

  @shortdoc " Run the neural network app "

  def run(args) do
    epoch_count = 10_000

    IO.puts("")

    {:ok, network_pid} = Network.start_link([1, 1])
    {:ok, network_pid} = Network.start_link([2, 1])
    Trainer.train(network_pid, training_data(), %{epochs: epoch_count, log_freqs: 1000})
    IO.puts("*****************************************************************")
    IO.puts("")
    IO.puts("== OR ==")
    examine(network_pid, [0, 0])
    examine(network_pid, [0, 1])
    examine(network_pid, [1, 0])
    examine(network_pid, [1, 1])
  end

  # inline training data in one file to see what's happening
  def training_data do
    [
      %{input: [0, 0], output: [0]},
      %{input: [0, 1], output: [0]},
      %{input: [1, 0], output: [0]},
      %{input: [1, 1], output: [1]}
    ]
  end

  @doc """
  Function that helpls to see the output
  """
  defp examine(network_pid, inputs) do
    val = network_pid |> Network.get() |> Network.activate(inputs)
    network = Network.get(network_pid)
    output_layer = Layer.get(network.output_layer)

    outputs =
      output_layer.neurons
      |> Enum.map(&Neuron.get(&1).output)

    IO.puts("#{inspect(inputs)} => #{inspect(outputs)}")
  end
end
