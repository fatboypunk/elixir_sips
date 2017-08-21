defmodule PhoenixCommerce.Acceptance.ProductTest do
  use PhoenixCommerce.AcceptanceCase
  use Hound.Helpers

  alias PhoenixCommerce.Product
  alias PhoenixCommerce.Repo

  @upload %Plug.Upload{
    content_type: "image/png",
    filename: "logo-email-b32a431e5255c913b4959a8a99016066.png",
    path: "/Users/marcel/code/elixir_sips/phoenix_commerce/test/files/logo-email-b32a431e5255c913b4959a8a99016066.png"
  }

  setup do
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

  test "/products/has a list of products" do
    navigate_to "/products"
    assert find_element(:css, ".products")
  end


  test "/products - product details include name, description image and price", %{product: product} do
    navigate_to "/products"
    product_li = find_element(:css, "ul.products li")
    name = find_within_element(product_li, :css, "h3")
    price = find_within_element(product_li, :css, "h4")
    description = find_within_element(product_li, :css, "p")
    image = find_within_element(product_li, :css, "img")

    assert visible_text(name) == product.name
    assert visible_text(price) == "$ #{product.price}"
    assert visible_text(description) == product.description
    assert attribute_value(image, "src") == ~r/uploads/
  end

  test "/products - click a product to view its details", %{product: product} do
    navigate_to "/products"

    find_element(:css, "ul.products li")
    |> find_within_element( :css, "a")
    |> click

    assert "/products/#{product.id}" == current_path
  end
end
