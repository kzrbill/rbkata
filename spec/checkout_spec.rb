describe 'Item' do
    it 'itemA should equal itemA' do
        expect(Item.new(:itemA)).to eq(Item.new(:itemA))
    end

    it 'itemA should not equal itemB' do
        expect(Item.new(:itemA)).not_to eq(Item.new(:itemB))
    end
end

describe 'Discount observations' do
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
