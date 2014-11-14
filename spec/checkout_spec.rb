class Checkout
    def initialize(observer)
        @observer = observer
    end

    def scan item
        @observer.item_scanned(item)
        Checkout.new(@observer)
    end
end

class Item
    attr_reader :id

    def initialize id
        @id = id
    end

    def ==(other)
        @id == other.id
    end

    alias eql? ==

    def hash
        @id.hash
    end
end

class Money
    def initialize amount
        @amount = amount
    end

    def ==(other)
        @amount == other.amount
    end

    attr_reader :amount
end

class DiscountCalculator
    def initialize observer
        @observer = observer
        @statuses = {
            Item.new(:itemA) => {:count => 0, :threshhold => 3, :amount => Money.new(20)},
            Item.new(:itemB) => {:count => 0, :threshhold => 2, :amount => Money.new(30)},
        }
    end

    def item_scanned(item)

        iterate(item)

        if (is_at_threshold?(item))

            @observer.discount_notification(item_hash(item)[:amount])
            reset(item)

        end
    end

    def iterate(item)
        item_hash = item_hash(item)
        item_hash[:count] = item_hash[:count] + 1
    end

    def reset(item)
        item_hash = item_hash(item)
        item_hash[:count] = 0
    end

    def is_at_threshold?(item)
        item_hash = item_hash(item)
        item_hash[:count] == item_hash[:threshhold]
    end

    def item_hash(item)
        @statuses[item]
    end

end

describe 'Item' do
    it 'itemA should equal itemA' do
        expect(Item.new(:itemA)).to eq(Item.new(:itemA))
    end

    it 'itemA should not equal itemB' do
        expect(Item.new(:itemA)).not_to eq(Item.new(:itemB))
    end
end

describe 'Checkout' do
    before(:each) do
        @discount = Money.new(0)

        disount_observer = self
        scan_observer = DiscountCalculator.new(disount_observer)
        @checkout = Checkout.new(scan_observer)
    end

    def discount_notification discount
        @discount = discount
    end

    it 'should give 0 discount when 2 itemAs scanned' do

        itemA = Item.new(:itemA)

        @checkout
        .scan(itemA)
        .scan(itemA)

        expect(@discount).to eq(Money.new(0))
    end

    it 'should give 20 discount when 3 itemAs scanned' do

        itemA = Item.new(:itemA)

        @checkout
        .scan(itemA)
        .scan(itemA)
        .scan(itemA)

        expect(@discount).to eq(Money.new(20))
    end

    it 'should give 30 discount when 2 itemBs scanned' do

        itemB = Item.new(:itemB)

        @checkout
        .scan(itemB)
        .scan(itemB)

        expect(@discount).to eq(Money.new(30))
    end
end
