module PictureTag
  DEFAULT_PRESET = { 'markup' => 'auto',
                     'formats' => ['original'],
                     'widths' => [400, 600, 800, 1000],
                     'fallback_width' => 800,
                     'fallback_format' => 'original',
                     'noscript' => false,
                     'link_source' => false,
                     'quality' => 75,
                     'format_quality' => { 'webp' => 50,
                                           'avif' => 30,
                                           'jp2' => 30 },
                     'data_sizes' => true,
                     'keep' => 'attention',
                     'dimension_attributes' => false,
                     'strip_metadata' => true,
                     'image_options' => {
                       'avif' => { 'compression' => 'av1', 'speed' => 8 }
                     } }.freeze

  STOCK_PRESETS = {
    'jpt-webp' => { 'formats' => %w[webp original] },

    'jpt-avif' => { 'formats' => %w[avif webp original] },

    'jpt-lazy' => { 'markup' => 'data_auto',
                    'noscript' => true,
                    'formats' => %w[webp original],
                    'attributes' => { 'parent' => 'class="lazy"' } },

    'jpt-loaded' => { 'formats' => %w[avif jp2 webp original],
                      'dimension_attributes' => true },

    'jpt-direct' => { 'markup' => 'direct_url',
                      'fallback_format' => 'webp',
                      'fallback_width' => 600 },

    'jpt-thumbnail' => { 'base_width' => 250,
                         'pixel_ratios' => [1, 1.5, 2],
                         'formats' => %w[webp original],
                         'fallback_width' => 250,
                         'attributes' => { 'picture' => 'class="icon"' } },

    'jpt-avatar' => { 'base_width' => 100,
                      'pixel_ratios' => [1, 1.5, 2],
                      'fallback_width' => 100,
                      'crop' => '1:1' }
  }.freeze

  STOCK_MEDIA_QUERIES = {
    'jpt-mobile' => 'max-width: 480px',
    'jpt-tablet' => 'max-width: 768px',
    'jpt-laptop' => 'max-width: 1024px',
    'jpt-desktop' => 'max-width: 1200px',
    'jpt-wide' => 'min-width: 1201px'
  }.freeze
end
