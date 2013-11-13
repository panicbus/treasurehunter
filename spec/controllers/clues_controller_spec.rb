require 'spec_helper'

describe CluesController do
  describe 'POST create' do
    it 'should create a new clue' do
      expect{ post :create, clue: {question: 'new question', answer: 'new answer', location_id: 1}}.to change(Clue, :count).by(1)
    end
  end

  context 'incorrect params sent' do
    it 'should not create a new clue' do
      expect{ post :create, clue: {question: 'new question'}}.to_not change(Clue, :count)
    end
  end

  describe 'DELETE clue' do
    it 'should delete the clue' do
      Clue.create(question: 'why', answer: 'why')
      expect{ delete :destroy, id: 1}.to change(Clue, :count).by(-1)
    end
  end
end
