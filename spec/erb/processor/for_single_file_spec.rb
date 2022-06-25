# frozen_string_literal: true

RSpec.describe ERB::Processor::ForSingleFile do
  let(:erb_processor) { described_class.new("./foo/bar/a_template_file.c.erb") }

  describe ".template_file?" do
    it "properly identify template files" do
      expect(described_class.template_file?("foo.bar.erb")).to be true
      expect(described_class.template_file?("foo/bar.erb")).to be true
      expect(described_class.template_file?("foo/bar.ERB")).to be true
      expect(described_class.template_file?("foo/bar/baz.ErB")).to be true
    end

    it "rejects non template files" do
      expect(described_class.template_file?("foo/bar/baz.ErBz")).to be false
      expect(described_class.template_file?("foo/bar.erb/baz.baz")).to be false
    end
  end

  describe "#run" do
    it "writes a processed version of the template" do
      allow(erb_processor).to receive(:processed_path).at_least(:once).
        and_return(:target_path)

      allow(erb_processor).to receive(:processed_content).
        and_return("<processed_content>")

      file_object = instance_double(File, "output")

      allow(File).to receive(:open).with(:target_path, "w+").
        and_yield(file_object)

      expect(file_object).to receive(:print).with("<processed_content>")

      erb_processor.run
    end
  end

  describe "#processed_content" do
    it "uses ERB to process the template" do
      allow(erb_processor).to receive(:template_content).
        and_return("evaluated expression to <%= 4+6 -%>")

      expect(erb_processor.processed_content).to eq("evaluated expression to 10")
    end
  end

  describe "#template_content" do
    it "read template file" do
      allow(File).to receive(:read).with("./foo/bar/a_template_file.c.erb").
        and_return("<template_content>")

      expect(erb_processor.template_content).to eq("<template_content>")
    end
  end

  describe "#processed_path" do
    it { expect(erb_processor.processed_path).to eq("./foo/bar/a_template_file.c") }
  end

  describe "#commented_processed_header" do
    it "returns a commented header according to the C language" do
      expect(erb_processor.commented_processed_header).to eq <<~EXPECTED_HEADER
        /*

        WARNING: DO NOT EDIT directly

        HOWTO Modify this file
        1. Edit the file ./foo/bar/a_template_file.c.erb
        2. $ erb-processor .

        */
      EXPECTED_HEADER
    end
  end

  describe "#processed_header" do
    it "returns an evaluated header" do
      expect(erb_processor.processed_header).to eq <<~EXPECTED_HEADER

        WARNING: DO NOT EDIT directly

        HOWTO Modify this file
        1. Edit the file ./foo/bar/a_template_file.c.erb
        2. $ erb-processor .

      EXPECTED_HEADER
    end
  end
end
