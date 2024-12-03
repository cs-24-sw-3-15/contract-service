require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  setup do
    @document = create(:document)
  end

  test "basic document validates" do
    assert @document.valid?
    assert @document.file.attached?
    assert_not_nil @document.file.download
  end
end
