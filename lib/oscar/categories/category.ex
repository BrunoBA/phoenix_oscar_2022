defmodule Oscar.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Oscar.Nominees.Nominee

  schema "categories" do
    field :name, :string

    has_many :nominees, Nominee

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
