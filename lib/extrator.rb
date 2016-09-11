require_relative './extrator/mfa'
require_relative './extrator/statement'

module Extractor
  class Base
    def extract(target)
      raise "Implement extra method"
    end
  end
end
