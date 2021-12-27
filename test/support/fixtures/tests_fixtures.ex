defmodule LiveK8s.TestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveK8s.Tests` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        from: "some from",
        name: "some name",
        number: 42
      })
      |> LiveK8s.Tests.create_event()

    event
  end
end
