defmodule LibraryFees do
  def datetime_from_string(string) do
    {:ok, dt} = NaiveDateTime.from_iso8601(string)
    dt
  end

  def before_noon?(datetime) do
    Time.before?(NaiveDateTime.to_time(datetime), ~T[12:00:00])
  end

  def return_date(checkout_datetime) do
    days = if before_noon?(checkout_datetime) do
      28
    else
      29
    end
    NaiveDateTime.add(checkout_datetime, days, :day)
    |> NaiveDateTime.to_date()
  end

  def days_late(planned_return_date, actual_return_datetime) do
    returned_date = NaiveDateTime.to_date(actual_return_datetime)
    if Date.after?(returned_date, planned_return_date) do
      Date.diff(returned_date, planned_return_date)
    else
      0
    end
  end

  def monday?(datetime) do
    day = NaiveDateTime.to_date(datetime)
    |> Date.day_of_week()
    day == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    checkout_dt = datetime_from_string(checkout)
    return_dt = datetime_from_string(return)
    expected_return = return_date(checkout_dt)
    days_late = days_late(expected_return, return_dt)
    monday = monday?(return_dt)
    trunc(rate * days_late * if monday, do: 0.5, else: 1)
  end
end
