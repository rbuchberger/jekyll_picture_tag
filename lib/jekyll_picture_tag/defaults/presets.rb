module PictureTag
  DEFAULT_PRESET = { 'markup' => 'auto',
                     'formats' => ['original'],
                     'widths' => [400, 600, 800, 1000],
                     'fallback_width' => 800,
                     'fallback_format' => 'original',
                     'noscript' => false,
                     'link_source' => false,
                     'quality' => 75,
                     'data_sizes' => true,
                     'keep' => 'attention',
                     'dimension_attributes' => false,
                     'strip_metadata' => true,
                     'image_options' => {
                       'avif' => { 'compression' => 'av1', 'speed' => 8 }
                     } }.freeze

end
