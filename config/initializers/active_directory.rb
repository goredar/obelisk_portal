conf = YAML.load_file(Rails.root.join('config/ad.yml')).fetch(Rails.env)

module ActiveDirectory
  module Contacts
    @mapping = {}
    def self.setup(mapping)
      @mapping = mapping
    end
    def self.update
      users = ActiveDirectory::User.find(:all)
      Contact.delete_all
      users.reject { |u| u[:name].include? "Test User" }.map do |u|
        k = @mapping.values
        v = @mapping.keys.map { |attr| u.valid_attribute?(attr) ? u.send(attr).force_encoding("UTF-8") : nil }
        Contact.new(Hash[k.zip v]).save!
      end
    end
  end
end

ActiveDirectory::Base.setup conf.fetch :ldap_params
ActiveDirectory::Contacts.setup conf.fetch :mapping
ActiveDirectory::Contacts.update