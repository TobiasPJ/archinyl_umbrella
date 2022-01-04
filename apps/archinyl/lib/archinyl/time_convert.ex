defmodule Archinyl.TimeConvert do
  def to_str(time) do
    to_str(time, :ms)
  end

  def to_str(time, :ms) do
    ms_to_str(time)
  end

  def to_str(time, :seconds) do
    sec_to_str(time)
  end

  defp sec_to_str(sec) do
    sec
    |> floor()
    |> Time.from_seconds_after_midnight()
  end

  defp ms_to_str(ms), do: ms |> div(1000) |> sec_to_str()
end
