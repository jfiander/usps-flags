module USPSFlags::Errors
  class PNGGenerationError < StandardError
    def initialize(msg = "There was an error generating the PNG file.", svg: "")
      super(msg)
    end
  end

  class StaticFilesGenerationError < StandardError
    def initialize(msg = "There was an error generating the static files.", cause: nil)
      super(msg)
    end
  end

  class ZipGenerationError < StandardError
    def initialize(msg = "There was an error generating the zip file.", type:, cause: nil)
      super(msg)
    end
  end
end
