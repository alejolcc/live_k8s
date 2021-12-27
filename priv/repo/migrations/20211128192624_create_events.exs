defmodule LiveK8s.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :from, :string
      add :number, :integer
      add :name, :string
    end
  end
end
