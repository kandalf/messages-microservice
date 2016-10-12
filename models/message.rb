class Message < Sequel::Model
  def self.search(options = { language: "%", limit: 100 })
    where("language LIKE (?)", "%#{options[:language]}%").order(Sequel.desc(:created_at)).limit(options[:limit])
  end
end
