defmodule PhoenixCommerce.LineItemTest do
  use PhoenixCommerce.ModelCase

  alias PhoenixCommerce.{LineItem, Product, Cart, Product}

  @product Product.changeset(%Product{}, %{
    name: "foo",
    price: Decimal.new("20.00"),
    description: "som foooo"
  }) |> Repo.insert!
  @cart Repo.insert!(%Cart{})

  @valid_attrs %{quantity: 42, product_id: @product.id, cart_id: @cart.id}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LineItem.changeset(%LineItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LineItem.changeset(%LineItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
