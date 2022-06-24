# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Erb::Processor::LanguageCommenter do
  context "instance methods" do
    let(:subject) do
      Erb::Processor::LanguageCommenter.new("foo/bar/a_template_path.erb", <<~END_OF_TEXT_TO_COMMENT)
        Multiline text to
        comment
      END_OF_TEXT_TO_COMMENT
    end

    describe "#comment" do
      let(:text_to_comment) do
        <<~END_OF_TEXT
          A multiline text
          that should be properly commented
        END_OF_TEXT
      end

      it do
        expect_comment_for("file.c", <<~EOEC)
          /*
          A multiline text
          that should be properly commented
          */
        EOEC
      end

      it do
        expect_comment_for("file.py", <<~EOEC)
          # A multiline text
          # that should be properly commented
        EOEC
      end

      def expect_comment_for(target_path, expected_comment)
        expect(subject).to receive(:target_file_path).and_return(target_path)
        expect(subject).to receive(:text_to_comment).and_return(text_to_comment)

        expect(subject.commented_text).to eq(expected_comment)
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
        expect(subject).to receive(:target_file_path).and_return(target_path)

        expect(subject.processed_language).to eq(expected_processed_language)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
