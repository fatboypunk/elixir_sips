defmodule PhoenixCommerce.LineItemController do
  use PhoenixCommerce.Web, :controller

  alias PhoenixCommerce.LineItem

  def update(conn, %{"id" => id, "line_item" => line_item_params}) do
    line_item = Repo.get!(LineItem, id)
    changeset = LineItem.changeset(line_item, line_item_params)

    case Repo.update(changeset) do
      {:ok, _line_item} ->
        conn
        |> put_flash(:info, "Line item updated succesfully.")
        |> redirect(to: cart_path(conn, :show))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was a problem updating the line_item.")
        |> redirect(to: cart_path(conn, :show))
    end
  end

  def delete(conn, %{"id" => id}) do
    LineItem
    |> Repo.get(id)
    |> Repo.delete

    conn
    |> put_flash(:info, "Line item removed from cart succesfully.")
    |> redirect(to: cart_path(conn, :show))
  end

end
