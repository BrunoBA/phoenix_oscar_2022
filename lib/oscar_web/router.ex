defmodule OscarWeb.Router do
  use OscarWeb, :router
  import Phoenix.LiveView.Helpers

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {OscarWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OscarWeb.Plugs.SetUser
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/login", OscarWeb do
    pipe_through :browser

    get "/", LoginController, :index
  end

  scope "/auth", OscarWeb do
    pipe_through :browser

    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", OscarWeb do
    pipe_through :browser

    live "/", NomineeControllerLive, :nominees
    live "/live", PageLive
    live "/nominees", NomineeControllerLive, :nominees
    live "/my_bets", MyBetsControllerLive, :my_bets
    live "/ranking", RankingControllerLive, :rankings
  end

  # Other scopes may use custom stacks.
  # scope "/api", OscarWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: OscarWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
