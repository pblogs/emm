require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  describe 'page alias' do
    it 'should accept small latin letters, digits, dots, dashes and underscores' do
      user.page_alias = 'abc-xyz_01.5.9'
      expect(user).to be_valid
    end

    it 'should not accept other symbols' do
      expect(user.update(page_alias: 'ABCXYZ')).to be_falsey
      expect(user.update(page_alias: 'abcxyz/')).to be_falsey
      expect(user.update(page_alias: 'abcxyz*')).to be_falsey
      expect(user.update(page_alias: 'abcxyz%')).to be_falsey
      expect(user.update(page_alias: 'abcxyz#')).to be_falsey
      expect(user.update(page_alias: 'abcxyz@')).to be_falsey
      expect(user.update(page_alias: 'abcxyz=')).to be_falsey
      expect(user.update(page_alias: 'abc xyz')).to be_falsey
    end
  end
end
