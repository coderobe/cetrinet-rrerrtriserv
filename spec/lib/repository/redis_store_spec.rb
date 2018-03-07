# frozen_string_literal: true

require "spec_helper"

require "rrerrtriserv/repository/redis_store"

RSpec.describe Rrerrtriserv::Repository::RedisStore do
  describe "#channel_create" do
    let(:channel_name) { "#lobby" }

    subject { described_class.channel_create(channel_name: channel_name) }

    it "creates the channel" do
      with_redis do |r|
        expect(r.sismember("channels", channel_name)).to be false
        subject
        expect(r.sismember("channels", channel_name)).to be true
      end
    end

    it { is_expected.to be true }

    context "channel already exists" do
      before do
        described_class.channel_create(channel_name: channel_name)
      end

      it { is_expected.to be false }
    end
  end

  describe "#channel_list" do
    subject { described_class.channel_list }

    context "no channels created" do
      it { is_expected.to eq [] }
    end

    context "one channel created" do
      before do
        described_class.channel_create(channel_name: "#channel1")
      end

      it { is_expected.to eq ["#channel1"] }
    end

    context "more channels created" do
      before do
        1.upto 5 do |i|
          described_class.channel_create(channel_name: "#channel#{i}")
        end
      end

      it { is_expected.to include("#channel1", "#channel2", "#channel3", "#channel4", "#channel5") }
    end
  end

  describe "#channel_join" do
    let(:user)    { "user1" }
    let(:channel) { "#lobby" }

    before do
      with_redis do |r|
        r.del("channel:#{channel}:users")
      end
    end

    subject { described_class.channel_join(user: user, channel_name: channel) }

    context "channel does not exist" do
      it { is_expected.to be false }

      it "does not add an user to the channel" do
        with_redis do |r|
          expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq []
          subject
          expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq []
        end
      end
    end

    context "channel exists" do
      before do
        described_class.channel_create(channel_name: channel)
      end

      it { is_expected.to be true }

      it "adds the user to the channel's user list" do
        with_redis do |r|
          expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq []
          subject
          expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq ["user1"]
        end
      end

      context "user already joined channel" do
        before do
          described_class.channel_join(user: user, channel_name: channel)
        end

        it { is_expected.to be true }

        it "does not add the user to the channel's user list again" do
          with_redis do |r|
            expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq ["user1"]
            subject
            expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq ["user1"]
          end
        end
      end
    end
  end

  describe "#channel_part" do
    let(:user)    { "user1" }
    let(:channel) { "#lobby" }

    before do
      with_redis do |r|
        r.del("channel:#{channel}:users")
      end
    end

    subject { described_class.channel_part(user: user, channel_name: channel) }

    context "channel does not exist" do
      it { is_expected.to be false }

      it "does not remove an user from the non-existing channel" do
        with_redis do |r|
          expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq []
          subject
          expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq []
        end
      end
    end

    context "channel exists" do
      before do
        described_class.channel_create(channel_name: channel)
        described_class.channel_join(user: "randomplayer", channel_name: channel)
      end

      context "user is not in channel" do
        it { is_expected.to be true }

        it "does not remove an user from the channel" do
          with_redis do |r|
            expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq ["randomplayer"]
            subject
            expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq ["randomplayer"]
          end
        end
      end

      context "user is in channel" do
        before do
          described_class.channel_join(user: user, channel_name: channel)
        end

        it { is_expected.to be true }

        it "removes the user from the user list" do
          with_redis do |r|
            expect(r.zrange("channel:#{channel}:users", 0, -1).sort).to eq ["randomplayer", "user1"]
            subject
            expect(r.zrange("channel:#{channel}:users", 0, -1)).to eq ["randomplayer"]
          end
        end
      end
    end
  end

  describe "#channel_user_list" do
    let(:channel) { "#lobby" }

    before do
      with_redis do |r|
        r.del("channel:#{channel}:users")
      end
    end

    subject { described_class.channel_user_list(channel_name: channel) }

    context "channel does not exist" do
      it { is_expected.to eq [] }
    end

    context "channel exists" do
      before do
        described_class.channel_create(channel_name: channel)
      end

      context "no users in channel" do
        it { is_expected.to eq [] }
      end

      context "one user in channel" do
        before do
          described_class.channel_join(user: "user1", channel_name: channel)
        end

        it { is_expected.to eq ["user1"] }
      end

      context "many users in channel" do
        before do
          1.upto 5 do |i|
            described_class.channel_join(user: "user#{i}", channel_name: channel)
          end
        end

        it { is_expected.to include(*("user1".."user5")) }
      end
    end
  end
end
