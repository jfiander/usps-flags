# frozen_string_literal: false

# Custom errors.
#
# @private
module USPSFlags::Errors
  class PNGGenerationError < StandardError
    attr_reader :svg

    def initialize(msg = 'There was an error generating the PNG file.', svg: '')
      super(msg)
      @svg = svg
    end
  end

  class PNGConversionError < StandardError
    def initialize(msg = 'There was an error converting the PNG file.')
      super(msg)
    end
  end

  class StaticFilesGenerationError < StandardError
    attr_reader :cause

    def initialize(msg = 'There was an error generating the static files.', cause: nil)
      super(msg)
      @cause = cause
    end
  end

  class ZipGenerationError < StandardError
    attr_reader :type, :cause

    def initialize(msg = 'There was an error generating the zip file.', type: nil, cause: nil)
      super(msg)
      @type = type
      @cause = cause
    end
  end
end
