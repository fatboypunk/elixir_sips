defmodule PhoenixCommerce.Acceptance.CartTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session()

  alias PhoenixCommerce.LineItem
  alias PhoenixCommerce.Product
  alias PhoenixCommerce.Repo

  @upload %Plug.Upload{
    content_type: "image/png",
    filename: "logo-email-b32a431e5255c913b4959a8a99016066.png",
    path: "/Users/marcel/code/elixir_sips/phoenix_commerce/test/files/logo-email-b32a431e5255c913b4959a8a99016066.png"
  }

  setup do
    Repo.delete_all(LineItem)
    Repo.delete_all(Product)
    {:ok, product} =  
      Product.changeset(%Product{}, %{
        name: "some product", 
        description: "some product description",
        price: Decimal.new("2.25"),
        image: %Plug.Upload{
          content_type: "image/png",
          filename: "logo-email-b32a431e5255c913b4959a8a99016066.png",
          path: "/Users/marcel/code/elixir_sips/phoenix_commerce/test/files/logo-email-b32a431e5255c913b4959a8a99016066.png"
        }
    }) |> Repo.insert 
    {:ok, product: product}
  end

  test "/cart shows an empty cart" do
    navigate_to "/cart"

    assert visible_text(heading) == "Your cart"
    assert length(line_items)
  end

  test "adding_product to a cart shows product in cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click add_to_cart_button
    navigate_to "/cart"
    assert length(line_items)==1
    assert visible_text(hd(line_items)) =~ ~r/#{product.name}/
  end

  def heading, do:  find_element(:css, "h2")
  def cart, do:  find_element(:css, ".cart")
  def cart_table, do: find_within_element(cart, :css, "table")
  def cart_tbody, do: find_within_element(cart_table, :css, "tbody")
  def line_items, do: find_all_within_element(cart_tbody, :css, "tr")
  def add_to_cart_button, do: find_element(:css, "button.add-to-cart")
end
