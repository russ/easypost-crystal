module EasyPost
  class Error < Exception
    getter message : String?
    getter status : Int32?
    getter code : String?
    getter errors : JSON::Any?

    def initialize(@message = nil, @status = nil, @code = nil, @errors = nil)
      super(message)
    end

    def to_s
      "#{code} (#{status}): #{message} #{errors}".strip
    end

    def ==(other)
      other.is_a?(Error) &&
        message == other.message &&
        status == other.status &&
        code == other.code &&
        errors == other.errors
    end
  end
end
