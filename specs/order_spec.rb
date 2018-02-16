require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/order'
require 'awesome_print'
require 'csv'

Minitest::Reporters.use!

describe "Order Wave 1" do
  describe "#initialize" do
    it "Takes an ID and collection of products" do
      id = 1337
      order = Grocery::Order.new(id, {})

      order.must_respond_to :id
      order.id.must_equal id
      order.id.must_be_kind_of Integer

      order.must_respond_to :products
      order.products.length.must_equal 0
    end
  end

  describe "#total" do
    it "Returns the total from the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      sum = products.values.inject(0, :+)
      expected_total = sum + (sum * 0.075).round(2)

      order.total.must_equal expected_total
    end

    it "Returns a total of zero if there are no products" do
      order = Grocery::Order.new(1337, {})

      order.total.must_equal 0
    end
  end

  describe "#add_product" do
    it "Increases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Grocery::Order.new(1337, products)

      order.add_product("salad", 4.25)
      expected_count = before_count + 1
      order.products.count.must_equal expected_count
    end

    it "Is added to the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      order.add_product("sandwich", 4.25)
      order.products.include?("sandwich").must_equal true
    end

    it "Returns false if the product is already present" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Grocery::Order.new(1337, products)
      before_total = order.total

      result = order.add_product("banana", 4.25)
      after_total = order.total

      result.must_equal false
      before_total.must_equal after_total
    end

    it "Returns true if the product is new" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      result = order.add_product("salad", 4.25)
      result.must_equal true
    end
  end

  describe "#remove_product" do
    it "decreases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Grocery::Order.new(1337, products)

      order.remove_product("banana")
      expected_count = before_count - 1
      order.products.count.must_equal expected_count
    end

    it "removes the product from the collection" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      order.remove_product("banana")
      order.products.include?("banana").must_equal false
    end

    it "returns true if the product is successfully removed" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      order.remove_product("banana").must_equal true
    end

    it "returns false if the product is not in the collection" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      order.remove_product("sandwich").must_equal false
    end
  end
end

# TODO: change 'xdescribe' to 'describe' to run these tests
describe "Order Wave 2" do
  before do
    order_array = CSV.read('support/orders.csv')
    @orders = Grocery::Order.string_to_hash(order_array)
  end

  describe "Order.all" do
    it "Returns an array of all orders" do
      # TODO: Your test code here!
      orders = Grocery::Order.all

      orders.each_index do |i|
        orders[i].id.must_equal @orders[i].id
        orders[i].products.must_equal @orders[i].products
      end
    end

    it "Returns right number of oders" do
      orders = Grocery::Order.all

      orders.count.must_equal @orders.count
    end

    it "Returns accurate information about the first order" do
      # TODO: Your test code here!
      orders = Grocery::Order.all

      orders[0].id.must_equal @orders[0].id
      orders[0].products.must_equal @orders[0].products
    end

    it "Returns accurate information about the last order" do
      # TODO: Your test code here!
      orders = Grocery::Order.all

      orders.last.id.must_equal @orders.last.id
      orders.last.products.must_equal @orders.last.products
    end
  end

  describe "Order.find" do
    it "Can find the first order from the CSV" do
      # TODO: Your test code here!
      order_find = Grocery::Order.find(1)

      order_find.must_equal @orders[0].products
    end

    it "Can find the last order from the CSV" do
      # TODO: Your test code here!
      order_find = Grocery::Order.find(100)

      order_find.must_equal @orders[99].products
    end

    it "Raises an error for an order that doesn't exist" do
      # TODO: Your test code here!
      order_find = Grocery::Order.find(101)

      order_find.must_be_nil
    end
  end
end
