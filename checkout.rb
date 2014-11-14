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

# Smell: this not immutable, state is updated in count
# Note: also might be better to descibe discount statuses as classes which have behavior,
# such as increment etc, and would have less connascence of structure
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
            discount_amount = discount_amount(item)

            @observer.discount_notification(discount_amount)

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

    def discount_amount(item)
        item_hash = item_hash(item)
        item_hash[:amount]
    end

    def item_hash(item)
        @statuses[item]
    end
end