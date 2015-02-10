module ActiveDirectory
  class Contacts

    @@mapping = {}
    @@mutex = Mutex.new

    cattr_reader :admin_group

    def self.setup(settings)
      ActiveDirectory::Base.setup settings.fetch :ldap_params
      @@admin_group = settings.fetch :admin_group
      @@mapping = settings.fetch :mapping
      update
    end
    def self.update
      @@mutex.synchronize do
        start_time = DateTime.now.utc
        users = ActiveDirectory::User.find(:all)
        users.reject! { |u| u[:name].include? "Test User" }.map! do |u|
          k = @@mapping.values
          v = @@mapping.keys.map { |attr| u.valid_attribute?(attr) ? u.send(attr).force_encoding("UTF-8") : nil }
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

  class User
    def member_of?(group)
      return false unless group.is_a? String
      @entry.memberOf.map do |g|
        g.split(',').first.downcase.gsub /^cn=/, ''
      end.include? group.downcase
    end
    def admin?
      member_of? ActiveDirectory::Contacts.admin_group
    end
  end
end

ActiveDirectory::Contacts.setup YAML.load_file(Rails.root.join('config/ad.yml')).fetch(Rails.env)