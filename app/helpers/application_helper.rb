module ApplicationHelper
  def avatar_url(email)
    hash = Digest::SHA256.hexdigest email
    "https://gravatar.com/avatar/#{
      hash
    }?d=https%3A%2F%2Frobohash.org%2Fset_set4%2F#{
      hash
    }"
  end
end
