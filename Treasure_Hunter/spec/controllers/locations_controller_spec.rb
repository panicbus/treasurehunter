require 'spec_helper'

describe LocationsController do
  describe "POST create" do
    it "should create a new location" do
      expect{ post :create, location:{lat: 137.888, long: -64.33333}}.to change(Location, :count).by(1)
    end
  end

context "incomplete params are sent" do
  it "should not add to database" do
    expect{post :create, location: {lat: 45}}.to_not change(Location, :count)
  end
end


  describe "delete location" do
    it "should delete location by id" do
      Location.create(lat: 1, long: 2)
      expect{delete :destroy, id: 1}.to change(Location, :count).by(-1)
    end
  end
end
