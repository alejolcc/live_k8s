defmodule LiveK8s.Tests.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :from, :string
    field :name, :string
    field :number, :integer
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:from, :number, :name])
    |> validate_required([:from, :number])
  end
end
