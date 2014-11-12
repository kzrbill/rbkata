class Checkout

    def initialize observer
        @observer = observer
    end

    def scan item
        @observer.item_scanned
    end

end

class Item 
    def initialize key
    end
end

describe 'Checkout' do

    before(:each) do
        @item_scan_count = 0
        @discount = 0
    end

    def item_scanned
        @item_scan_count = @item_scan_count.next
        if (@item_scan_count == 3)
            @discount = 20
        end
    end

    it 'should give 20 discount when 3 itemAs scanned' do

        itemA = Item.new "A"

        checkout = Checkout.new self
        checkout.scan(itemA)
        checkout.scan(itemA)
        checkout.scan(itemA)

        expect(@discount).to eq(20)
    end

    it 'should give 30 discount when 2 itemBs scanned' do

        itemB = Item.new "B"

        checkout = Checkout.new self
        checkout.scan(itemB)
        checkout.scan(itemB)

        expect(@discount).to eq(30)
    end

end