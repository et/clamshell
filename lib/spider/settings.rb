module Spider
  class Settings < Hash
    def initialize
      super
      self[:git_auto_pull] = false
      self[:skip_check] = false
    end
  end
end
