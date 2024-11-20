require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  test "does not accept files larger than 50 MiB" do
    document = Document.new(title: "Test document")
    file = mock_file(size: 50.megabytes, content_type: "application/pdf", filename: "testfile.pdf")
    document.file.attach(io: file)

    assert_not document.valid?
  end
end

module DocumentHelper
  # Helper method to create a mock file
  def mock_file(size:, content_type:, filename:)
    file_mock = StringIO.new
    def file_mock.size
      @size
    end
    file_mock.instance_variable_set(:@size, size)
    file_mock.define_singleton_method(:original_filename) { filename }
    file_mock.define_singleton_method(:content_type) { content_type }
    file_mock
  end
end