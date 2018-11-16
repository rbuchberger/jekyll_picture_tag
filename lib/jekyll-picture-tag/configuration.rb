# Allows us to access settings with PictureTag.config
module PictureTag
  class << self
    attr_accessor :config
  end

  def self.init(raw_tag_params, context)
    self.config = InstructionSet.new(raw_tag_params, context)
  end

  def self.preset
    config.preset
  end

  def self.media_preset
    config.media_preset
  end
end
