defmodule SipsMatcher do
  use GenFSM

  # Public API

  def start_link do
    {:ok, fsm} = :gen_fsm.start_link(__MODULE__, [], [])
    fsm
  end

  def consume_s(fsm) do
    :gen_fsm.sync_send_event(fsm, :s)
  end

  def consume_not_s(fsm) do
    :gen_fsm.sync_send_event(fsm, :not_s)
  end

  # GenFSM API

  def init(_) do
    {:ok, :starting, [] }
  end

  def starting(:s, _from, state_data) do
    {:reply, :got_s, :got_s, state_data}
  end

  def starting(:not_s, _from, state_data) do
    {:reply, :starting, :starting, state_data}
  end
end

defmodule SipsMatcherTest do
  use ExUnit.Case

  test "[:starting] it successfully consume the string 's'" do
    fsm = SipsMatcher.start_link
    assert SipsMatcher.consume_s(fsm) == :got_s
  end

  test "[:starting] it successuflly consume strings other than 's'" do
    fsm = SipsMather.start_link
    assert SipsMatcher.consume_not_s(fsm) == :starting
  end
end
