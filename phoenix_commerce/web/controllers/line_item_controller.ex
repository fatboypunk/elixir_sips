defmodule PhoenixCommerce.LineItemController do
  use PhoenixCommerce.Web, :controller

  alias PhoenixCommerce.LineItem

  def delete(conn, %{"id" => id}) do
    LineItem
    |> Repo.get(id)
    |> Repo.delete

    conn
    |> put_flash(:info, "Line item removed from cart succesfully.")
    |> redirect(to: cart_path(conn, :show))
  end

end
