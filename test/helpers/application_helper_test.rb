require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test 'it responds to content_pack (default)' do
    assert respond_to?(:content_pack)
  end

  test 'it responds to provide_content_pack (default)' do
    assert respond_to?(:provide_content_pack)
  end

  test 'it responds to custom_pack' do
    assert respond_to?(:custom_pack)
  end

  test 'it responds to provide_custom_pack' do
    assert respond_to?(:provide_custom_pack)
  end

  test '#content_pack accepts content as second argument' do
    content_pack('id', 'c1')
    assert_equal 'c1', provide_content_pack
  end

  test '#content_pack accepts content as block argument' do
    content_pack('id') { 'c1' }
    assert_equal 'c1', provide_content_pack
  end

  test '#content_pack passes id as block argument' do
    id = nil
    content_pack('id') { |id_arg| id = id_arg }
    assert_equal 'id', id
  end

  test'#content_pack concatenates content under same id with "append" option' do
    content_pack('id', 'c1')
    content_pack('id', nil, append: true) { 'c2' }
    assert_equal 'c1c2', provide_content_pack
  end


  test '#content_pack replaces content under same id with "flush" option' do
    content_pack('id', 'c1')
    content_pack('id', 'c2', flush: true)
    assert_equal 'c2', provide_content_pack
  end

  test '#provide_content_pack returnes all content under named pack' do
    content_pack('id1') { 'c1' }
    content_pack('id2') { 'c2' }
    assert_equal 'c1c2', provide_content_pack
  end

  test '#content_pack & #custom_pack are separated by scope' do
    content_pack('id', 'c1')
    custom_pack('id', 'c2', flush: true)
    assert_equal 'c1', provide_content_pack
    assert_equal 'c2', provide_custom_pack
  end

  test '#content_pack_get returnes content entry by given id' do
    content_pack('1', 'c1')
    content_pack('2', 'c2')
    assert_equal content_pack_get('2'), 'c2'
  end
end
