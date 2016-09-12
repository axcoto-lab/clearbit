require_relative './extrator/mfa'
require_relative './extrator/statement'

module Extractor
  class Base
    def self.extract(user)
      statement = user.transactions
      statement_domain = Extractor::Statement.extract(statement)
      statement_domain
    end
  end
end
