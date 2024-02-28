describe Fastlane::Actions::CommonAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The common plugin is working!")

      Fastlane::Actions::CommonAction.run(nil)
    end
  end
end
