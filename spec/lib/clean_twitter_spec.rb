require 'spec_helper'
require 'clean_twitter'

describe CleanTwitter do
  describe '#fix_handle' do
    it 'strips http' do
      expect(CleanTwitter.fix_handle("http://twitter.com/ltw_")).to eq "ltw_"
    end
    it 'strips https' do
      expect(CleanTwitter.fix_handle("https://twitter.com/missthang_679")).to eq "missthang_679"
    end
    it 'strips leading at-symbols' do
      expect(CleanTwitter.fix_handle("@ltw_")).to eq "ltw_"
    end
  end
end
