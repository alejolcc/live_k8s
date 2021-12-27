defmodule LiveK8s.TestsTest do
  use LiveK8s.DataCase

  alias LiveK8s.Tests

  describe "events" do
    alias LiveK8s.Tests.Event

    import LiveK8s.TestsFixtures

    @invalid_attrs %{from: nil, name: nil, number: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Tests.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Tests.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{from: "some from", name: "some name", number: 42}

      assert {:ok, %Event{} = event} = Tests.create_event(valid_attrs)
      assert event.from == "some from"
      assert event.name == "some name"
      assert event.number == 42
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tests.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{from: "some updated from", name: "some updated name", number: 43}

      assert {:ok, %Event{} = event} = Tests.update_event(event, update_attrs)
      assert event.from == "some updated from"
      assert event.name == "some updated name"
      assert event.number == 43
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Tests.update_event(event, @invalid_attrs)
      assert event == Tests.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Tests.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Tests.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Tests.change_event(event)
    end
  end
end
