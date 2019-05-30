# frozen_string_literal: false

# Custom errors.
#
# @private
module USPSFlags::Errors
  class PNGGenerationError < StandardError
    def initialize(msg = 'There was an error generating the PNG file.', svg: '')
      super(msg)
    end
  end

  class PNGConversionError < StandardError
    def initialize(msg = 'There was an error converting the PNG file.')
      super(msg)
    end
  end

  class StaticFilesGenerationError < StandardError
    def initialize(msg = 'There was an error generating the static files.', cause: nil)
      super(msg)
    end
  end

  class ZipGenerationError < StandardError
    def initialize(msg = 'There was an error generating the zip file.', type: nil, cause: nil)
      super(msg)
    end
  end
end
