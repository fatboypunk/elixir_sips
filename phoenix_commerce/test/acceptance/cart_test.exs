defmodule PhoenixCommerce.Acceptance.CartTest do
  use PhoenixCommerce.AcceptanceCase
  use Hound.Helpers

  alias PhoenixCommerce.{LineItem, Product, Repo}

  @upload %Plug.Upload{
          content_type: "image/png",
          filename: "logo-email-b32a431e5255c913b4959a8a99016066.png",
          path: "/Users/marcel/code/elixir_sips/phoenix_commerce/test/files/logo-email-b32a431e5255c913b4959a8a99016066.png"
        }

  setup do
    {:ok, product} =
      Product.changeset(%Product{}, %{
        name: "some product",
        description: "some product description",
        price: Decimal.new("2.25"),
        image: @upload
    }) |> Repo.insert
    {:ok, product: product}
  end

  test "/cart shows an empty cart" do
    navigate_to "/cart"

    assert visible_text(heading()) == "Your cart"
    assert length(line_items())
  end

  test "adding_product to a cart shows product in cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click add_to_cart_button
    navigate_to "/cart"
    assert length(line_items())==1
    assert visible_text(hd(line_items())) =~ ~r/#{product.name}/
  end

  test "different sessions should have different carts", %{product: product} do
    navigate_to "/products/#{product.id}"
    click add_to_cart_button()
    navigate_to "/cart"

    assert length(line_items()) == 1

    change_session_to("second user")
    navigate_to "/cart"
    assert length(line_items()) == 0
  end

  test "removing an item from the cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click add_to_cart_button()
    navigate_to "/cart"
    assert length(line_items()) == 1

    click(remove_from_cart_button(product))
    assert length(line_items()) == 0
  end

  test "updaing the line items quantity", %{product: product} do
    navigate_to "/products/#{product.id}"
    click add_to_cart_button()
    update_quantity(product, 5)
    assert quantity(product) == 5
  end

  def heading, do:  find_element(:css, "h2")
  def cart, do:  find_element(:css, ".cart")
  def cart_table, do: find_within_element(cart(), :css, "table")
  def cart_tbody, do: find_within_element(cart_table(), :css, "tbody")
  def line_items, do: find_all_within_element(cart_tbody, :css, "tr")
  def add_to_cart_button, do: find_element(:css, "button.add-to-cart")
  def remove_from_cart_button(product) do
    product_row(product)
    |> find_within_element(:css, ".remove-from-cart")
  end
  def product_row(product) do
    find_element(:css, "tr.product-#{product.id}")
  end
  def quantity_field(product) do
    product_row(product)
    |> find_within_element(:css, ".quantity")
  end
  def update_quantity(product, quantity) do
    quantity_field(product)
    |> fill_field(quantity)

    quantity_field(product)
    |> submit_element
  end
  def quantity(product) do
    {quantity, _} =
      quantity_field(product)
      |> attribute_value(:value)
      |> Integer.parse

    quantity
  end
end
