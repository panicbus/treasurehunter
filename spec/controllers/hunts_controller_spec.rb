require 'spec_helper'

describe HuntsController do
  describe 'POST create' do
    it 'should create a new hunt' do
      expect{ post :create, hunt: {description: 'new description', title: 'new title'}}.to change(Hunt, :count).by(1)
    end
  end

  context "incomplete params are sent" do
    it "should not create a hunt" do
      expect{post :create, hunt: {description: 'new description'}}.to_not change(Hunt, :count)
    end
  end

  describe 'POST delete' do
    it 'should delete a hunt by id' do
       Hunt.create(description: 'new description', title: 'new title')
      expect{delete :destroy, id: 1}.to change(Hunt, :count).by(-1)
    end
  end
end