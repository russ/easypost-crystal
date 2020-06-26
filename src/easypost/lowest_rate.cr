module EasyPost
  module LowestRate
    def lowest_rate(carriers : Array(String) = [] of String, services : Array(String) = [] of String)
      get_rates if rates.nil?

      lowest_rate = nil
      carriers = carriers.map(&.downcase)
      services = services.map(&.downcase)

      negative_carriers = [] of String
      negative_services = [] of String

      carriers.clone.each do |carrier|
        if carrier[0, 1] == "!"
          negative_carriers << carrier[1..-1]
          carriers.delete(carrier)
        end
      end

      services.clone.each do |service|
        if service[0, 1] == "!"
          negative_services << service[1..-1]
          services.delete(service)
        end
      end

      rates.not_nil!.each do |rate|
        rate_carrier = rate.carrier.not_nil!.downcase
        next if carriers.size > 0 && !carriers.includes?(rate_carrier)
        next if negative_carriers.size > 0 && negative_carriers.includes?(rate_carrier)

        rate_service = rate.service.not_nil!.downcase
        next if services.size > 0 && !services.includes?(rate_service)
        next if negative_services.size > 0 && negative_services.includes?(rate_service)

        if lowest_rate.nil? || rate.rate.to_f < lowest_rate.not_nil!.rate.to_f
          lowest_rate = rate
        end
      end

      raise Error.new("No rates found.") if lowest_rate.nil?

      lowest_rate
    end
  end
end
