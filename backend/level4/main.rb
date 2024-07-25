# frozen_string_literal: true

require 'json'
require 'date'

# quick one liners, never fails
input_hash = JSON.parse(File.read('./data/input.json'))

class RentalBalance
  def self.summary(days, price_per_day, distance, price_per_km)
    instance = new(days, price_per_day, distance, price_per_km)
    instance.summary
  end

  def initialize(number_of_days, price_per_day, distance, price_per_km)
    @price_per_day = price_per_day
    @number_of_days = number_of_days
    @distance = distance
    @price_per_km = price_per_km
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

  def rental_price
    @rental_price ||= days_price(@number_of_days) + @price_per_km * @distance
  end

  def fees_part
    @fees_part ||= (rental_price * 0.3).to_i
  end

  def driver_balance
    {
      'who' => 'driver',
      'type' => 'debit',
      'amount' => rental_price
    }
  end

  def insurance_fee
    @insurance_fee ||= (fees_part / 2).to_i
  end

  def assistance_fee
    @assistance_fee ||= @number_of_days * 100
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
      'amount' => fees_part - insurance_fee - assistance_fee
    }
  end

  def owner_balance
    {
      'who' => 'owner',
      'type' => 'credit',
      'amount' => rental_price - fees_part
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

processed_input = {
  'rentals' =>
   input_hash['rentals'].map do |rental|
     car = input_hash['cars'].find { |car_ietm| car_ietm['id'] == rental['car_id'] }
     # + 1 because all days inclusive
     number_of_days = (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i + 1
     {
       'id' => rental['id'],
       'actions' => RentalBalance.summary(
         number_of_days,
         car['price_per_day'],
         rental['distance'],
         car['price_per_km']
       )
     }
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
