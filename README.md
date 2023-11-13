# InvestimentPlatform

To start your Phoenix server:

  * Run `docker-compose up` to up database container.
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint inside IEx with `iex -S mix phx.server`
  * Run `InvestimentPlatformWorkers.InsertStockQuotes.perform(%{"paths" => ["/path", ...]})` to populate database. 
    You should save files on local machine and pass it directory as parameter.

Now you can visit [localhost:4000/stocks_quotes/reports?ticker=WDOZ23&start_date=2023-10-24](localhost:4000/stocks_quotes/reports?ticker=WDOZ23&start_date=2023-10-24) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
