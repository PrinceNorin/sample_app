module UsersHelper
  def gravatar_for(user, options={})
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    gravatar_url += "?s=#{options[:size]}" if options[:size]
    image_tag gravatar_url, alt: user.name, class: 'gravatar'
  end
end
