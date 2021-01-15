module Stubs
  # Handles stubbed picture configuration
  module Presets
    def build_defaults
      @widths = [25, 50, 100]
      @pconfig = {}
      @pdata = picture_data_stub

      @jekyll_env = 'development'
      @site_dest = temp_dir
      @jconfig = { 'picture' => @pconfig,
                   'keep_files' => [],
                   'destination' => @site_dest,
                   'url' => 'example.com' }
      @data = { 'picture' => @pdata }
      @page = { 'ext' => 'html' }
      @site_source = File.join TestHelper::TEST_DIR, 'image_files'
      @cache_dir = temp_dir('cache')
    end

    def picture_data_stub
      { 'presets' => presets,
        'media_queries' => media_queries }
    end

    def media_queries
      { 'mobile' => 'max-width: 600px' }
    end

    def presets
      {
        'default' => {
          'widths' => @widths
        },

        'auto' => {
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'data_auto' => {
          'markup' => 'data_auto',
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'data_img' => {
          'markup' => 'data_img',
          'widths' => @widths
        },

        'data_picture' => {
          'markup' => 'data_picture',
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'data_img_no_size' => {
          'markup' => 'data_img',
          'widths' => @widths,
          'sizes' => {
            'mobile' => '80vw'
          },
          'size' => '50%',
          'data_sizes' => false
        },

        'data_img_yes_size' => {
          'markup' => 'data_img',
          'widths' => @widths,
          'sizes' => {
            'mobile' => '80vw'
          },
          'size' => '50%',
          'data_sizes' => true
        },

        'direct_url' => {
          'markup' => 'direct_url',
          'fallback_width' => 100
        },

        'img' => {
          'markup' => 'img',
          'widths' => @widths
        },

        'naked_srcset' => {
          'markup' => 'naked_srcset',
          'widths' => @widths
        },

        'sizes' => {
          'sizes' => {
            'mobile' => '80vw'
          },
          'size' => '50%'
        },

        'pixel_ratio' => {
          'base_width' => 10,
          'pixel_ratios' => [1, 2, 3]
        },

        'attributes' => {
          'formats' => %w[webp original],
          'widths' => @widths,
          'attributes' => {
            'parent' => 'class="parent"',
            'alt' => 'Alternate Text',
            'a' => 'class="anchor"',
            'picture' => 'data-awesomeness="11"',
            'source' => 'class="source"',
            'img' => 'class="img"'
          }
        },

        'link_source' => {
          'widths' => @widths,
          'link_source' => true
        },

        'media_widths' => {
          'widths' => @widths,
          'media_widths' => {
            'mobile' => [10, 20, 30]
          }
        },

        'data_noscript' => {
          'markup' => 'data_img',
          'widths' => @widths,
          'noscript' => true
        },

        'fallback' => {
          'widths' => @widths,
          'fallback_width' => 35,
          'fallback_format' => 'webp'
        },

        'nomarkdown' => {
          'widths' => @widths,
          'nomarkdown' => true
        },

        'too_large' => {
          'widths' => [400, 600, 800],
          'fallback_width' => 800
        },

        'formats' => {
          'widths' => [100],
          'fallback_width' => 100,
          'formats' => %w[jpg jp2 png webp gif]
        },

        'quality' => {
          'widths' => [100],
          'quality' => 30,
          'format_quality' => {
            'webp' => 45
          }
        },

        'format_quality' => {
          'widths' => [100],
          'quality' => 30,
          'format_quality' => {
            'jpg' => 45
          }
        },

        'calculated_quality' => {
          'quality' => {
            50 => 50,
            100 => 100
          }
        },

        'calculated_quality_reverse' => {
          'quality' => {
            100 => 100,
            50 => 50
          }
        },

        'crop' => {
          'crop' => '3:2',
          'media_crop' => {
            'mobile' => '16:9'
          },
          'gravity' => 'north',
          'media_gravity' => {
            'mobile' => 'northwest'
          }
        },

        'dimension_attributes' => {
          'dimension_attributes' => true
        },

        'dimension_attributes_multiformat' => {
          'dimension_attributes' => true,
          'formats' => %w[original webp]
        },

        'dimension_attributes_replace_values' => {
          'dimension_attributes' => true,
          'attributes' => {
            'img' => {
              'height' => 'auto'
            }
          }

        }
      }
    end
  end
end
