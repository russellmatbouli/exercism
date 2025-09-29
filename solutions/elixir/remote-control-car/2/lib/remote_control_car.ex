defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [
    :nickname,
    battery_percentage: 100,
    distance_driven_in_meters: 0,
  ]

  def new(nickname \\ "none")
  def new(nickname) do
    %RemoteControlCar{nickname: nickname}
  end

  def display_distance(remote_car) when is_struct(remote_car, RemoteControlCar) do
    "#{remote_car.distance_driven_in_meters} meters"
  end

  def display_battery(remote_car) when is_struct(remote_car, RemoteControlCar) do
    if remote_car.battery_percentage == 0 do
      "Battery empty"
    else
      "Battery at #{remote_car.battery_percentage}%"
    end
  end

  def drive(remote_car) when is_struct(remote_car, RemoteControlCar) do
    batt = remote_car.battery_percentage
    dist = remote_car.distance_driven_in_meters
    if batt != 0 do
      %{remote_car | battery_percentage: batt - 1, distance_driven_in_meters: dist + 20 }
    else
      remote_car
    end
  end
end
