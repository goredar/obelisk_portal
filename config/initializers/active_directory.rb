conf = YAML.load_file(Rails.root.join('config/ad.yml')).fetch(Rails.env)

module ActiveDirectory
  module Contacts

    @mapping = {}
    @mutex = Mutex.new

    def self.setup(mapping)
      @mapping = mapping
    end
    def self.update
      @mutex.synchronize do
        start_time = DateTime.now.utc
        users = ActiveDirectory::User.find(:all)
        users.reject! { |u| u[:name].include? "Test User" }.map! do |u|
          k = @mapping.values
          v = @mapping.keys.map { |attr| u.valid_attribute?(attr) ? u.send(attr).force_encoding("UTF-8") : nil }
          Hash[k.zip v]
        end
        # Update or create
        users.each do |user|
          user_in_db = Contact.find_by_login user.fetch(:login)
          user_in_db ? (user_in_db.update!(user); user_in_db.touch) : Contact.new(user).save!
        end
        # Delete old records (not in AD now)
        Contact.where("updated_at < :start_time", start_time: start_time).find_each { |c| c.destroy }
      end
    end
  end
end

ActiveDirectory::Base.setup conf.fetch :ldap_params
ActiveDirectory::Contacts.setup conf.fetch :mapping
ActiveDirectory::Contacts.update