module EasyPost
  class Resource < EasyPostObject
    include JSON::Serializable

    def self.resource_name
      camel = self.name.split("::")[-1]
      (camel[0..0] + camel[1..-1].gsub(/([A-Z])/, "_\\1")).downcase
    end

    def self.path
      if self.resource_name == "resource"
        raise Exception.new("Resource is an abstract class. You should perform actions on its subclasses (Address, Shipment, etc.)")
      end

      if (self.resource_name[-1..-1] == "s" || self.resource_name[-1..-1] == "h")
        "/v2/#{URI.encode(self.resource_name.downcase)}es"
      else
        "/v2/#{URI.encode(resource_name.downcase)}s"
      end
    end

    def self.retrieve(id)
      self.from_json(
        EasyPost.make_request(
          "GET",
          "#{self.path}/#{id}"
        )
      )
    end

    def path
      if @id.nil?
        raise Exception.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{@id.inspect}")
      else
        "#{self.class.path}/#{URI.encode(@id.not_nil!)}"
      end
    end

    def create
      self.class.from_json(
        EasyPost.make_request(
          "POST",
          self.class.path,
          {self.class.resource_name => self}
        )
      )
    end
  end
end
