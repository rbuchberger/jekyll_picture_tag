module PictureTag
  # Default settings for _config.yml
  DEFAULT_CONFIG = {
    'picture' => {
      'source' => '',
      'output' => 'generated',
      'suppress_warnings' => false,
      'relative_url' => true,
      'cdn_environments' => ['production'],
      'nomarkdown' => true,
      'ignore_missing_images' => false,
      'disabled' => false,
      'fast_build' => false,
      'ignore_baseurl' => false,
      'baseurl_key' => 'baseurl'
    }
  }.freeze
end
