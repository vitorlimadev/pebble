defmodule Watcher do
  require Logger
  use Broadway
  alias Broadway.Message

  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwayKafka.Producer,
          [
            hosts: "localhost:9092",
            group_id: "all_orders",
            topics: ["orders"],
            client_config: []
          ]
        },
        concurrency: 10
      ],
      processors: [
        default: [concurrency: 2]
      ],
      batchers: [
        orders_batcher: [concurrency: 2, batch_size: 10, batch_timeout: 1000]
      ]
    )
  end

  def handle_message(_, message, _) do
    message
    |> Message.put_batcher(:orders_batcher)
    |> IO.inspect()
  end
end
