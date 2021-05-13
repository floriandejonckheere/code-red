# frozen_string_literal: true

module CodeRed
  module Version
    MAJOR = 0
    MINOR = 6
    PATCH = 0
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  VERSION = CodeRed::Version::STRING
end
