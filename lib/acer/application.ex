defmodule Acer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Acer.Worker.start_link(arg)
      # {Acer.Worker, arg},
      {Ace.HTTP.Service, [
          {MyApp, %{greeting: "Hello"}},
          [port: 8080, cleartext: true]
        ]
      }
    ]

    opts = [strategy: :one_for_one, name: Acer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule MyApp do
  use Raxx.Server

  @impl Raxx.Server
  def handle_request(%{method: :GET, path: []}, %{greeting: greeting}) do
    Raxx.response(:ok)
    |> Raxx.set_header("content-type", "text/plain")
    |> Raxx.set_body("#{greeting}, World!")
  end
  def handle_request(_request, _state) do
    Raxx.response(404)
  end
end