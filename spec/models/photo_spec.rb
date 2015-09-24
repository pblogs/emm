require 'rails_helper'
require 'spec_helper'

RSpec.describe Photo, type: :model do

  it_behaves_like 'album_record'
end
