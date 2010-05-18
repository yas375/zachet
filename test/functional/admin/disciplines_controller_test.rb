require 'test_helper'

class DisciplinesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Discipline.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Discipline.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Discipline.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to discipline_url(assigns(:discipline))
  end
  
  def test_edit
    get :edit, :id => Discipline.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Discipline.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Discipline.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Discipline.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Discipline.first
    assert_redirected_to discipline_url(assigns(:discipline))
  end
  
  def test_destroy
    discipline = Discipline.first
    delete :destroy, :id => discipline
    assert_redirected_to disciplines_url
    assert !Discipline.exists?(discipline.id)
  end
end
