module ActiveDirectory
  class User
    def member_of?(group)
      return false unless group.is_a? String
      @entry.memberOf.map do |g|
        g.split(',').first.downcase.gsub /^cn=/, ''
      end.include? group.downcase
    end
    def role
      Contact.user_roles.inject(:user) do |r, group|
        member_of?(group[1]) ? group[0] : r
      end
    end
  end
end

ActiveDirectory::Base.setup YAML.load_file(Rails.root.join('config/ad.yml')).fetch(Rails.env)
Contact.update_all_from_ldap