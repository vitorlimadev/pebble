defmodule Pebble do
  @moduledoc """
  Pebble keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def create_order(order \\ "pizza") do
    hosts = [localhost: 9092]
    client_id = :all_orders

    :ok = :brod.start_client(hosts, client_id)

    :ok = :brod.start_producer(client_id, "orders", [])

    :brod.produce(
      client_id,
      "orders",
      :rand.uniform(3) - 1,
      Integer.to_string(:rand.uniform(3000)),
      order
    )
  end
end
