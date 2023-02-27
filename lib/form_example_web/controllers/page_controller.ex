defmodule FormExampleWeb.PageController do
  use FormExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_user(conn, params) do
    res =
      params
      |> map_to_gleam_user()
      |> :shared_gleam.validate_form()

    case res do
      {:ok, user} ->
        resp = gleam_user_to_map(user)

        conn
        |> put_resp_content_type("application/json")
        |> put_status(200)
        |> json(%{user: resp})

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> put_status(400)
        |> json(%{error: reason})
    end
  end

  ## Gleam conversion functions
  defp map_to_gleam_user(params) do
    {
      :dynamic_user,
      params["fname"],
      params["lname"],
      params["email"],
      params["password"],
      params["country"],
      params["ssn"]
    }
  end

  defp gleam_user_to_map({:user, fname, lname, email, password, country, ssn}) do
    %{
      "fname" => fname,
      "lname" => lname,
      "email" => email,
      "password" => password,
      "country" => country,
      "ssn" => ssn,
    }
  end
end
