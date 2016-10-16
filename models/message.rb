class Message < Sequel::Model
  def self.search(options = { language: "%", limit: 100 })
    where("language LIKE (?)", "%#{options[:language]}%").order(Sequel.desc(:created_at)).limit(options[:limit])
  end

  def to_hash
    values.merge(created_at: created_at.iso8601, updated_at: updated_at.iso8601)
  end
end
