module Extractor
  class Mfa
    def self.extract(object)
      info_user.mfa.select { |m| m[:type] == 'email' }.map do |m|
        result = Clearbit::Enrichment.find(email: m[:mask], stream: true)
        result.company
      end
    end
  end
end
