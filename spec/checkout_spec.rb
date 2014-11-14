class Checkout
    def initialize(observer)
        @observer = observer
    end

    def scan item
        @observer.item_scanned
        Checkout.new(@observer)
    end
end

class Item
    def initialize key
    end
end

class DiscountCalculator
    def initialize observer
        @discount = 0
        @observer = observer

        @item_scan_count = 0
    end

    def item_scanned
        @item_scan_count = @item_scan_count.next
        if @item_scan_count == 3
            @observer.discount_notification 20
        elsif @item_scan_count == 2
            @observer.discount_notification 30
        end
    end
end

# Refactor to immutable.
# Next up: maybe add a test to check scanning itemA twice gives 0 discount.
# This will force the refactor.

describe 'Checkout' do
    before(:each) do
        @discount = 0

        disount_observer = self
        scan_observer = DiscountCalculator.new(disount_observer)

        @checkout = Checkout.new(scan_observer)
    end

    def discount_notification discount
        @discount = discount
    end

    it 'should give 20 discount when 3 itemAs scanned' do

        itemA = Item.new("A")

        @checkout
        .scan(itemA)
        .scan(itemA)
        .scan(itemA)

        expect(@discount).to eq(20)
    end

    it 'should give 30 discount when 2 itemBs scanned' do

        itemB = Item.new("B")

        @checkout
        .scan(itemB)
        .scan(itemB)

        expect(@discount).to eq(30)
    end
end
