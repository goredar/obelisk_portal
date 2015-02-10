class Contact < ActiveRecord::Base

  cattr_reader :user_roles
  @@user_roles = {
    admin: "_BookAdmins",
    manager: "_BookManagers",
  }
  cattr_reader :role_can_edit
  @@role_can_edit = Hash.new([])
  @@role_can_edit[:admin] = %i[extension mobile home company department title mail photo]
  @@role_can_edit[:manager] = %i[mobile home photo]
  @@role_can_edit[:user] = %i[photo]

  cattr_reader :ldap_mapping
  @@ldap_mapping = {
    samaccountname: :login,
    displayname: :name,
    ipphone: :extension,
    mobile: :mobile,
    homephone: :home,
    company: :company,
    department: :department,
    title: :title,
    mail: :mail,
  }

  PHOTO_PATH = File.expand_path("public/images/contacts/", Rails.root)

  def self.update_all_from_ldap
    start_time = DateTime.now.utc
    (users = ActiveDirectory::User.find(:all)) rescue return(nil)
    users.reject! { |u| u[:name].include? "Test User" }.map! do |u|
      k = @@ldap_mapping.values
      v = @@ldap_mapping.keys.map { |attr| u.valid_attribute?(attr) ? u.send(attr).force_encoding("UTF-8") : nil }
      Hash[k.zip v]
    end
    # Update or create
    users.each do |user|
      user_in_db = find_by_login user.fetch(:login)
      user_in_db ? (user_in_db.update!(user); user_in_db.touch) : self.new(user).save!
    end
    # Delete old records (not in AD now)
    self.where("updated_at < :start_time", start_time: start_time).find_each { |c| c.destroy }
    users.count
  end

  def self.auth(user, pass)
    (ldap_user = ActiveDirectory::User.find(:first, :samaccountname => user)) rescue return(false)
    if ldap_user && ldap_user.authenticate(pass)
      u = find_by_login user
      u.update! :role => ldap_user.role
      u
    else
      false
    end
  end

  def save_photo(io)
    if io
      photo = MiniMagick::Image.read io.read
      photo.resize "90x90"
      photo.format "png"
      filename = File.expand_path "photo_#{self.id}.png", PHOTO_PATH
      photo.write filename
      File.chmod 0644, filename
      self.photo = "photo_#{self.id}.png"
    else
      self.photo = nil
    end
  end

  def permited_actions
    @@role_can_edit[role.to_sym]
  end

  def allowed?(action)
    @@role_can_edit[role.to_sym].include? action.to_sym
  end
end