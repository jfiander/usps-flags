require 'spec_helper'

describe USPSFlags::Generate do
  it "should get the correct flag" do
    expect(USPSFlags::Generate.get("LtC", outfile: "")).to include("width=\"1024pt\" height=\"682pt\" viewBox=\"0 0 3072 2048\"")
    expect(USPSFlags::Generate.get("LtC", outfile: "")).to include(
      <<~SVG
        <path d="M 0 0
          l 3072 0
          l 0 2048
          l -3072 0
          l 0 -2048
        " fill="#BF0D3E" />
      SVG
    )
    expect(USPSFlags::Generate.get("LtC", outfile: "")).to include("<path d=\"M 1536 512")
    expect(USPSFlags::Generate.get("LtC", outfile: "")).to include("<g transform=\"translate(-512)\">")
    expect(USPSFlags::Generate.get("LtC", outfile: "")).to include("<g transform=\"translate(512)\">")
  end
end
