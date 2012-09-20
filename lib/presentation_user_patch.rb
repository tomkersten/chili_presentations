module VideoUserPatch
  def self.included(base) # :nodoc:
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      has_many :presentations, :dependent => :destroy
    end
  end
end

