# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe ERB::Processor::LanguageCommenter do
  let(:text_to_comment) do
    <<~END_OF_TEXT
      A multiline text
      that should be properly commented
    END_OF_TEXT
  end

  def commenter_for(target_path)
    described_class.new(target_path, text_to_comment)
  end

  describe "#comment" do
    # rubocop:disable RSpec/ExampleLength
    it do
      expect_comment_for("file.c", <<~EOEC)
        /*
        A multiline text
        that should be properly commented
        */
      EOEC
    end
    # rubocop:enable RSpec/ExampleLength

    it do
      expect_comment_for("file.py", <<~EOEC)
        # A multiline text
        # that should be properly commented
      EOEC
    end

    it { expect_comment_for("path/to/unknown0-file-type", text_to_comment) }

    def expect_comment_for(target_path, expected_comment)
      expect(commenter_for(target_path).commented_text).to eq(expected_comment)
    end
  end

  describe "#processed_language" do
    it { expect_language_for("code.c", :c) }
    it { expect_language_for("code.cpp", :cpp) }
    it { expect_language_for("code.js", :js) }
    it { expect_language_for("code.html", :html) }
    it { expect_language_for("code.py", :py) }
    it { expect_language_for("code.feature", :feature) }
    it { expect_language_for("code-with-no-extension", :unknown) }

    def expect_language_for(target_path, expected_processed_language)
      expect(commenter_for(target_path).processed_language).to eq(expected_processed_language)
    end
  end
end
# rubocop:enable Metrics/BlockLength
