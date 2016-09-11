module Extractor
  class Statement
    def self.extract(statement)
      statement.map do |s|
        s.name.split(/\s+/).map do |word|
          if m = /[\w]+\.[^\s]+/.match(word)
            m[0]
          else
            "stripe.com"
          end
        end.select { |d| !d.nil? && !d.empty?}
      end.flatten.uniq.map do |m|
        Clearbit::Enrichment::Company.find(domain: m, stream: true)
      end
    end
  end
end
