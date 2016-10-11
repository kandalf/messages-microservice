class Message < Sequel::Model
  def self.search(options = { language: "%", limit: 100 })
    where("language LIKE (?)", "%#{options[:language]}%").limit(options[:limit])
  end
end
