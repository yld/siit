# frozen_string_literal: true

require 'json'
require 'date'

# quick one liners, never fails
input_hash = JSON.parse(File.read('./data/input.json'))

class Options
  def initialize(options)
    @options = options
  end

  def find_by_rental_id(rental_id)
    @options.reduce([]) do |array, option|
      array << (option['rental_id'] == rental_id ? option['type'] : nil) # iteration can not do nothing
    end.compact
  end
end

class Cars
  def initialize(cars)
    @cars = cars
  end

  def find_by_id(id)
    @cars.find { |car| car['id'] == id }
  end
end

class RentalPayload
  def self.output(id, car, start_date, end_date, distance, options)
    instance = new(id, car, start_date, end_date, distance, options)
    instance.output
  end

  def initialize(id, car, start_date, end_date, distance, options)
    @id = id
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
    @options = options
  end

  def number_of_days
    (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
  end

  def output
    {
      'id' => @id,
      'options' => @options,
      'actions' => RentalBalance.summary(
        number_of_days,
        @car['price_per_day'],
        @distance,
        @car['price_per_km'],
        @options
      )
    }
  end
end

class RentalBalance
  def self.summary(days, price_per_day, distance, price_per_km, options)
    instance = new(days, price_per_day, distance, price_per_km, options)
    instance.summary
  end

  def initialize(number_of_days, price_per_day, distance, price_per_km, options)
    @price_per_day = price_per_day
    @number_of_days = number_of_days
    @distance = distance
    @price_per_km = price_per_km
    @options = options
  end

  def summary
    [
      driver_balance,
      owner_balance,
      insurance_balance,
      assistance_balance,
      drivy_balance
    ]
  end

  # everything bemow could be private

  def rental_price
    @rental_price ||= days_price(@number_of_days) + @price_per_km * @distance
  end

  def fees_part
    @fees_part ||= (rental_price * 0.3).to_i
  end

  def gps_fees
    @gps_fees ||= @options.include?('gps') ? @number_of_days * 500 : 0 # readme says 5
  end

  def baby_seat_fees
    @baby_seat_fees ||= @options.include?('baby_seat') ? @number_of_days * 200 : 0 # readme says 2
  end

  def additional_insurance_fees
    @additional_insurance_fees ||= @options.include?('additional_insurance') ? @number_of_days * 1000 : 0 # readme says 10
  end

  def insurance_fee
    @insurance_fee ||= (fees_part / 2).to_i
  end

  def assistance_fee
    @assistance_fee ||= @number_of_days * 100
  end

  # methods below could be factorized without so much gain (almost same code size)
  # we could also have a class Balance ; def intialize(who: :string, credit: :bool, amount: :integer)
  def driver_balance
    {
      'who' => 'driver',
      'type' => 'debit',
      'amount' => rental_price + gps_fees + baby_seat_fees + additional_insurance_fees
    }
  end

  def assistance_balance
    {
      'who' => 'assistance',
      'type' => 'credit',
      'amount' => assistance_fee
    }
  end

  def insurance_balance
    {
      'who' => 'insurance',
      'type' => 'credit',
      'amount' => insurance_fee
    }
  end

  def drivy_balance
    {
      'who' => 'drivy',
      'type' => 'credit',
      'amount' => fees_part - insurance_fee - assistance_fee + additional_insurance_fees
    }
  end

  def owner_balance
    {
      'who' => 'owner',
      'type' => 'credit',
      'amount' => rental_price - fees_part + gps_fees + baby_seat_fees
    }
  end

  def days_price(days)
    price = 0
    while days.positive?
      if days > 10
        price += 0.5 * @price_per_day * (days - 10)
        days = 10
      elsif days > 4
        price += 0.7 * @price_per_day * (days - 4)
        days = 4
      elsif days > 1
        price += 0.9 * @price_per_day * (days - 1)
        days = 1
      else # == 1
        price += @price_per_day
        days = 0 # loop out
      end
    end
    price.to_i # to_i useless
  end
end

# global variables
options = Options.new(input_hash['options'])
cars = Cars.new(input_hash['cars'])

processed_input = {
  'rentals' =>
   input_hash['rentals'].map do |rental|
     RentalPayload.output(
       rental['id'],
       cars.find_by_id(rental['car_id']),
       rental['start_date'],
       rental['end_date'],
       rental['distance'],
       options.find_by_rental_id(rental['id'])
     )
   end
}

# expected_output_hash = JSON.parse(File.read('./data/expected_output.json'))
# if processed_input == expected_output_hash
#   p "Succcess"
# else
#   p "Failure"
#   # quick debug
#   p "Input hash:"
#   pp input_hash
#   p "Expected output:"
#   pp expected_output_hash
#   p "Processed input"
#   pp processed_input
# end

pp processed_input
