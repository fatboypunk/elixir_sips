defmodule PhoenixCommerce.Image do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumb]
  @file_types ~w(.jpg .jpeg .gif .png)

  # Whitelist file extensions:
  def validate({file, _}) do
     Enum.member?(@file_types, Path.extname(file.file_name)) 
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png"}
  end
end
