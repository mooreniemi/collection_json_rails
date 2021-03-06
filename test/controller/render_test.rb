require 'minitest_helper'

class PostsController < ActionController::Base
  def without_serializer
    render json: { my_hash: "should be jsonified too" }
  end

  def empty_array
    render json: []
  end

  def empty_array_with_serializer_name
    render json: [], serializer: PostSerializer
  end

  def without_json
    render nothing: true
  end

  def rails_magic_render
  end
end

class TestRender < ActionController::TestCase
  tests PostsController

  def test_that_responds_with_collection_json
    get :index, {}

    assert_equal "application/vnd.collection+json", response.content_type
  end

  def test_that_an_empty_array_responds_with_success
    get :empty_array

    assert_response :ok
    assert_equal Mime::JSON, response.content_type
  end

  def test_that_a_serializer_name_can_be_specified
    get :empty_array_with_serializer_name

    assert_response :ok
    assert_equal "application/vnd.collection+json", response.content_type
  end

  def test_that_objects_without_serializer_are_rendered_as_plain_json
    get :without_serializer

    assert_response :ok
    assert_equal Mime::JSON, response.content_type
  end

  def test_that_render_behaves_as_usual
    get :without_json

    assert_response :ok
    assert_equal Mime::TEXT, response.content_type
  end

  def test_rails_magic_render_behaves_as_usual
    missing_template = "Missing template posts/rails_magic_render " +
      "with {:locale=>[:en], :formats=>[:html], :variants=>[], " +
      ":handlers=>[:erb, :builder, :raw, :ruby]}. Searched in:\n"
    error = assert_raises(ActionView::MissingTemplate) { get :rails_magic_render }
    assert_equal missing_template, error.message
  end
end

