# frozen_string_literal: true

RSpec.describe Erb::Processor::ForSingleFile do
  context "class methods" do
    describe ".template_file?" do
      let(:subject) { Erb::Processor::ForSingleFile }

      it "properly identify template files" do
        expect(subject.template_file?("foo.bar.erb")).to be true
        expect(subject.template_file?("foo/bar.erb")).to be true
        expect(subject.template_file?("foo/bar.ERB")).to be true
        expect(subject.template_file?("foo/bar/baz.ErB")).to be true
      end

      it "rejects non template files" do
        expect(subject.template_file?("foo/bar/baz.ErBz")).to be false
        expect(subject.template_file?("foo/bar.erb/baz.baz")).to be false
      end
    end
  end

  context "instance methods" do
    let(:subject) do
      Erb::Processor::ForSingleFile.new("foo/bar/a_template_path.erb")
    end

    describe "#run" do
      it "writes a processed version of the template" do
        expect(subject).to receive(:processed_path)
          .and_return(:target_path)

        expect(subject).to receive(:processed_content)
          .and_return("<processed_content>")

        file_object = double(":process_file")

        expect(File).to receive(:open).with(:target_path, "w+")
                                      .and_yield(file_object)

        expect(file_object).to receive(:print).with("<processed_content>")
        subject.run
      end
    end

    describe "#processed_content" do
      let(:erb_processor) { double(:erb_processor) }

      it "uses ERB to process the template" do
        expect(subject).to receive(:template_content)
          .and_return("evaluated expression to <%= 4+6 -%>")

        expect(subject.processed_content).to eq("evaluated expression to 10")
      end
    end

    describe "#template_content" do
      it "read template file" do
        expect(IO).to receive(:read).with("foo/bar/a_template_path.erb")
                                    .and_return("<template_content>")

        expect(subject.template_content).to eq("<template_content>")
      end
    end

    describe "#target_path" do
      it { expect(subject.processed_path).to eq("foo/bar/a_template_path") }
    end
  end
end
