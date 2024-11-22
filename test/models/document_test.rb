require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  test "basic fixture document validates" do
    basic_document = documents(:basic_document)

    assert basic_document.valid?
    assert basic_document.file.attached?
    assert_not_nil basic_document.file.download
  end
end
